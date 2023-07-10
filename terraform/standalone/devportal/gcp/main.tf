/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

data "google_compute_zones" "available" {
  region = var.region
}

resource "random_shuffle" "randomised_available_zones" {
  input = data.google_compute_zones.available.names
}

locals {
  public_ip_file       = "${path.module}/public_ip"
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

resource "google_compute_instance" "devportal_example" {
  name                                 = "devportal-example"
  machine_type                         = var.instance_type
  project                              = var.project_id 
  zone = random_shuffle.randomised_available_zones.result[0]

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
    startup-script = templatefile("${path.root}/../templates/startup.sh.tmpl", { 
      db_type              = var.db_type
      db_host              = var.db_host
      db_user              = var.db_user
      db_password          = var.db_password
      db_ca_cert_file      = var.db_ca_cert_file != null ? file(pathexpand(var.db_ca_cert_file)): null
      db_client_cert_file  = var.db_client_cert_file != null ? file(pathexpand(var.db_client_cert_file)) : null
      db_client_key_file   = var.db_client_key_file != null ? file(pathexpand(var.db_client_key_file)): null
   })
  }
  
  tags = ["nginx-devportal"]
}

resource "google_compute_firewall" "https_access" {
  name    = "nginx-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443", "80"]
  }

  source_ranges = var.incoming_cidr_blocks != null ? concat(var.incoming_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  target_tags = ["nginx-devportal"]
}


resource "null_resource" "example" {
  provisioner "remote-exec" {
    connection {
      host = google_compute_instance.devportal_example.network_interface[0].access_config[0].nat_ip
      user = var.ssh_user
      private_key = file(pathexpand(var.ssh_private_key))
    }

    inline = ["echo 'connected!'"]
  }
}