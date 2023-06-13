/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

locals {
  public_ip_file       = "${path.module}/public_ip"
}

module "nms_common" {
  source            = "../../modules/nms"
  admin_user        = var.admin_user
  admin_passwd      = var.admin_passwd
  host_default_user = var.ssh_user
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
}

resource "null_resource" "get_my_public_ip" {
  provisioner "local-exec" {
    command = "curl -sSf https://checkip.amazonaws.com > ${local.public_ip_file}"
  }
}

data "local_file" "my_public_ip" {
  depends_on = [null_resource.get_my_public_ip]
  filename   = local.public_ip_file
}

resource "google_compute_instance" "nms_example" {
  name         = "nms-example"
  machine_type = var.instance_type
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_pub_key))}"
    startup-script = templatefile("${path.root}/../templates/startup.sh.tmpl", { base64 = module.nms_common.htpasswd_data.content_base64 })
  }
  allow_stopping_for_update = true

  tags = ["nginx"]
}

resource "google_compute_firewall" "https_access" {
  name    = "nginx-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.incoming_cidr_blocks != null ? concat(var.incoming_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  target_tags = ["nginx"]
}
