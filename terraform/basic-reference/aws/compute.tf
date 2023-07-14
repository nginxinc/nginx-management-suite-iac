/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */
 
 data "aws_ami" "bastion_base_image" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["099720109477"]
}


module "nms_common" {
  source            = "../../modules/nms"
  admin_user        = var.admin_user
  admin_passwd      = var.admin_passwd
  host_default_user = var.ssh_user
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
}

module "agent_common" {
  source              = "../../modules/agent"
  host_default_user   = var.ssh_user
  nms_host_ip         = module.nms_alb.lb_dns_name
  instance_group_name = var.agent_instance_group_name
  ssh_pub_key         = pathexpand(var.ssh_pub_key)

  depends_on = [
    null_resource.apply_nms_license
  ]
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion-key-pair"
  public_key = file(pathexpand(var.ssh_pub_key))
}


resource "aws_instance" "nms_example" {
  ami                                  = var.nms_ami_id
  instance_type                        = var.nms_instance_type
  vpc_security_group_ids               = [aws_security_group.nms_secgroup.id]
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.controlplane_subnet_id
  user_data = module.nms_common.nms_cloud_init.rendered
  user_data_replace_on_change = true
  tags = {
    Name = "nms_example"
  }
}

resource "aws_instance" "bastion_example" {
  ami                                  = data.aws_ami.bastion_base_image.id
  instance_type                        = var.bastion_instance_type
  vpc_security_group_ids               = [aws_security_group.bastion_secgroup.id]
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.public_subnet_id
  associate_public_ip_address          = true
  key_name                              = aws_key_pair.bastion_key_pair.key_name 
  tags = {
    Name = "bastion_host"
  }
}

resource "aws_instance" "agent_example" {
  depends_on = [
    null_resource.apply_nms_license
  ]
  count                                = var.agent_count
  ami                                  = var.agent_ami_id
  instance_type                        = var.agent_instance_type
  vpc_security_group_ids               = [aws_security_group.agent_secgroup.id]
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.dataplane_subnet_id
  tags = {
    Name = "agent_example"
  }
  user_data = module.agent_common.agent_cloud_init.rendered
}

