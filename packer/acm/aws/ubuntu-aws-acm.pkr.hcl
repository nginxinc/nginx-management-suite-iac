variable "base_ami_name" {
  type    = string
}

variable "base_ami_owner_acct" {
  type    = string
}

variable "build_region" {
  type    = string
  default = "us-west-1"
}

variable "build_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "destination_regions" {
  type    = list(string)
  default = ["us-west-1"]
}

variable "ami_name"{
  type    = string
  default = null
}

variable "nginx_repo_cert" {
  type = string
}

variable "nginx_repo_key" {
  type = string
}

variable "subnet_id" {
  type = string
  default = null
}

variable "nms_api_connectivity_manager_version" {
  type    = string
  default = "1.3.1"
}

locals {
  version = replace(var.nms_api_connectivity_manager_version, ".", "-")
  ami_name = var.ami_name != null ? var.ami_name : "acm-ubuntu-20-04-${local.version}"
}

data "amazon-ami" "base_image" {
  filters = {
    name                = var.base_ami_name
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = [var.base_ami_owner_acct]
  region      = var.build_region
}

source "amazon-ebs" "disk" {
  ami_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 20
  }
  ami_name                  = local.ami_name
  ami_regions               = var.destination_regions
  instance_type             = var.build_instance_type
  region                    = var.build_region
  skip_region_validation    = true
  source_ami                = data.amazon-ami.base_image.id
  ssh_clear_authorized_keys = true
  ssh_username              = "ubuntu"
  subnet_id                 = var.subnet_id
}

build {
  sources = ["source.amazon-ebs.disk"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/debian-img-prep-apt.sh"]
  }

  provisioner "shell-local" {
    inline = ["${path.root}/../../scripts/write_acm_ansible_group_vars.sh ${var.nginx_repo_cert} ${var.nginx_repo_key} ${var.nms_api_connectivity_manager_version}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_SSH_ARGS='-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=ssh-rsa'", "ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
    extra_arguments  = ["-e ansible_ssh_pass=ubuntu"]
    groups           = ["acm"]
    playbook_file    = "${path.root}/../../ansible/play-acm.yml"
  }

  provisioner "shell" {
    scripts = ["${path.root}/../../scripts/required-setup-all.sh"]
  }

  post-processor "manifest" {
  }
}