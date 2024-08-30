/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1"
    }
  }
}

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

variable "nginx_instance_manager_version" {
  type    = string
  default = ""
}

variable "nms_api_connectivity_manager_version" {
  type    = string
  default = ""
}

variable "nms_security_monitoring_version" {
  type    = string
  default = ""
}

variable "project_id" {
  type    = string
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "network_name" {
  type    = string
  default = ""
}

variable "labels" {
  type    = map(string)
  default = {}
}

locals {
  timestamp = lower(formatdate("YYYY-MM-DD", timestamp()))
  image_name = var.image_name != null ? var.image_name : "nms-${local.timestamp}"
}

source "googlecompute" "gcp_disk" {
  project_id                = var.project_id
  zone                      = var.build_zone
  image_name                = local.image_name
  image_family              = "nginx-management-suite"
  image_labels              = var.labels
  source_image              = var.base_image_name
  machine_type              = var.build_instance_type
  ssh_clear_authorized_keys = true
  ssh_username              = var.ssh_username
  network                   = var.network_name
}

build {
  sources = ["source.googlecompute.gcp_disk"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/img-prep.sh"]
    expect_disconnect = true
  }

  provisioner "shell-local" {
    inline = ["${path.root}/../../scripts/write_nms_ansible_group_vars.sh ${var.nginx_repo_cert} ${var.nginx_repo_key} ${var.nginx_instance_manager_version} ${var.nms_api_connectivity_manager_version} ${var.nms_security_monitoring_version}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
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
