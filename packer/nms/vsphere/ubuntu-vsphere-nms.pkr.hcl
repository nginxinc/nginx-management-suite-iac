/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "boot_command" {
  type    = string
  default = "c<wait>linux /casper/vmlinuz --- autoinstall<enter><wait>initrd /casper/initrd <enter><wait>boot<enter>"
}

variable "nginx_repo_cert" {
  type = string
}

variable "nginx_repo_key" {
  type = string
}

variable "nms_api_connectivity_manager_version" {
  type    = string
  default = ""
}

variable "nms_app_delivery_manager_version" {
  type    = string
  default = ""
}

variable "nms_security_monitoring_version" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type    = string
}

variable "datacenter" {
  type    = string
}

variable "datastore" {
  type    = string
}

variable "iso_path" {
  type    = string
}

variable "network" {
  type    = string
}

variable "vsphere_password" {
  type      = string
  default   = "${env("VSPHERE_PASSWORD")}"
  sensitive = true
}

variable "vsphere_url" {
  type    = string
  default = "${env("VSPHERE_URL")}"
}

variable "vsphere_username" {
  type      = string
  default   = "${env("VSPHERE_USER")}"
  sensitive = true
}

variable "console_password" {
  type      = string
  default   = "${env("CONSOLE_PASSWORD")}"
  sensitive = true
}

variable "template_name" {
  type    = string
  default = null
}

locals {
  console_password = var.console_password != null ? var.console_password : "ubuntu"
  template_name = var.template_name != null ? var.template_name : "nms-ubuntu-22-04-${local.timestamp}"
}

source "vsphere-iso" "ubuntu" {
  CPUs                = 2
  RAM                 = 2048
  RAM_reserve_all     = true
  boot_command        = [var.boot_command]
  boot_wait           = "3s"
  cd_files            = ["./cloud-init/user-data", "./cloud-init/meta-data"]
  cd_label            = "cidata"
  cluster             = var.cluster_name
  convert_to_template = true
  datacenter          = var.datacenter
  datastore           = var.datastore
  guest_os_type       = "ubuntu64Guest"
  insecure_connection = true
  iso_paths           = ["[${var.datastore}] ${var.iso_path}"]
  network_adapters {
    network = var.network
  }
  password                  = var.vsphere_password
  ssh_clear_authorized_keys = true
  ssh_handshake_attempts    = "200"
  ssh_password              = local.console_password
  ssh_timeout               = "30m"
  ssh_username              = "ubuntu"
  storage {
    disk_size             = 20480
    disk_thin_provisioned = true
  }
  username       = var.vsphere_username
  vcenter_server = var.vsphere_url
  vm_name        = "${local.template_name}"
}

build {
  sources = ["source.vsphere-iso.ubuntu"]

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/debian-img-prep-apt.sh"]
  }

  provisioner "shell-local" {
    inline = ["${path.root}/../../scripts/write_nms_ansible_group_vars.sh ${var.nginx_repo_cert} ${var.nginx_repo_key} ${var.nms_api_connectivity_manager_version} ${var.nms_app_delivery_manager_version} ${var.nms_security_monitoring_version}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_SSH_ARGS=-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa", "ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
    extra_arguments  = ["-e ansible_ssh_pass=${local.console_password}"]
    groups           = ["nms"]
    playbook_file    = "${path.root}/../../ansible/play-nms.yml"
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/required-setup-all.sh"]
  }

  post-processor "manifest" {
  }
}
