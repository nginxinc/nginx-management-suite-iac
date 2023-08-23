/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
}

variable "base_image_offer" {
  type    = string
}

variable "base_image_sku" {
  type    = string
}

variable "base_image_publisher" {
  type    = string
}

variable "resource_group_name" {
  type    = string
  default = "West Central US"
}

variable "build_instance_type" {
  type    = string
  default = "Standard_B1s"
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

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  timestamp = formatdate("YYYY-MM-DD", timestamp())
  image_name = var.image_name != null ? var.image_name : "nms-${local.timestamp}"
}

source "azure-arm" "ubuntu" {
  build_resource_group_name         = var.resource_group_name
  image_offer                       = var.base_image_offer
  image_publisher                   = var.base_image_publisher
  image_sku                         = var.base_image_sku
  managed_image_name                = local.image_name
  managed_image_resource_group_name = var.resource_group_name
  os_type                           = "Linux"
  ssh_clear_authorized_keys         = true
  ssh_username                      = var.ssh_username
  vm_size                           = var.build_instance_type
  subscription_id                   = var.subscription_id
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  azure_tags                        = var.tags
}



build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/img-prep.sh"]
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
