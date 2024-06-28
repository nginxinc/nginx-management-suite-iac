/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

module "nms_common" {
  source            = "../../../modules/nms"
  admin_password    = var.admin_password
  host_default_user = var.ssh_user
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
  disks             = ""
}

resource "google_compute_instance" "nms_example" {
  name                      = "nms-example"
  machine_type              = var.instance_type
  project                   = var.project_id

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network = var.network_name
    access_config {
    }
  }
  metadata = {
    ssh-keys       = "${var.ssh_user}:${file(pathexpand(var.ssh_pub_key))}"
    startup-script = templatefile("${path.root}/../templates/startup.sh.tmpl", { base64 = module.nms_common.htpasswd_data.content_base64 })
  }
  allow_stopping_for_update = true

  tags                      = ["nginx"]
  labels                    = var.labels
}

resource "google_compute_firewall" "https_access" {
  name          = "nginx-firewall"
  network       = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.incoming_cidr_blocks
  target_tags   = ["nginx"]
}
