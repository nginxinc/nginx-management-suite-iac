/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "base_image_name" {
  type    = string
}

variable "build_zone" {
  type    = string
  default = "europe-west4-a"
}

variable "build_instance_type" {
  type    = string
  default = "e2-micro"
}

variable "image_name"{
  type    = string
  default = null
}

variable "nginx_repo_cert" {
  type = string
}

variable "nginx_repo_key" {
  type = string
}

variable "nms_api_connectivity_manager_version" {
  type    = string
  default = "1.6.0"
}

variable "nms_app_delivery_manager_version" {
  type    = string
  default = "4.0.0"
}

variable "nms_security_monitoring_version" {
  type    = string
  default = "1.5.0"
}

variable "project_id" {
  type    = string
}

locals {
  timestamp = lower(formatdate("DD-MMM-YY", timestamp()))
  image_name = var.image_name != null ? var.image_name : "nms-ubuntu-22-04-${local.timestamp}"
}

source "googlecompute" "gcp_disk" {
  project_id                = var.project_id
  zone                      = var.build_zone
  image_name                = local.image_name
  image_family              = "nginx-management-suite"
  source_image              = var.base_image_name
  machine_type              = var.build_instance_type
  ssh_clear_authorized_keys = true
  ssh_username              = "ubuntu"
}

build {
  sources = ["source.googlecompute.gcp_disk"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/debian-img-prep-apt.sh"]
  }

  provisioner "shell-local" {
    inline = ["${path.root}/../../scripts/write_nms_ansible_group_vars.sh ${var.nginx_repo_cert} ${var.nginx_repo_key} ${var.nms_api_connectivity_manager_version} ${var.nms_app_delivery_manager_version} ${var.nms_security_monitoring_version}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_SSH_ARGS=-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa", "ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
    extra_arguments  = ["-e ansible_ssh_pass=ubuntu"]
    groups           = ["nms"]
    playbook_file    = "${path.root}/../../ansible/play-nms.yml"
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/required-setup-all.sh"]
  }

  post-processor "manifest" {
  }
}
