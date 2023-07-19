/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available_zones" {
  state         = "available"
  exclude_names = ["us-west-2d"]
}

resource "random_shuffle" "random_az" {
  input = data.aws_availability_zones.available_zones.names
}

data "aws_subnet" "subnet" {
  count = var.subnet_id != null ? 1 : 0
  id    = var.subnet_id
}

locals {
  vpc_id               = var.subnet_id != null ? data.aws_subnet.subnet[0].vpc_id : module.vpc[0].vpc_id
  subnet_id            = var.subnet_id != null ? var.subnet_id : module.vpc[0].public_subnets[0]
}

module "vpc" {
  count  = var.subnet_id != null ? 0 : 1
  source = "terraform-aws-modules/vpc/aws"

  name = "nms_vpc"
  cidr = "10.0.0.0/16"

  azs            = [random_shuffle.random_az.result[0]]
  public_subnets = ["10.0.101.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "nms_common" {
  source            = "../../../modules/nms"
  admin_user        = var.admin_user
  admin_password    = var.admin_password
  host_default_user = var.ssh_user
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
}

resource "aws_instance" "nms_example" {
  ami                                  = var.ami_id
  instance_type                        = var.instance_type
  vpc_security_group_ids               = [aws_security_group.nms-secgroup.id]
  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.subnet_id
  user_data_replace_on_change          = true
  user_data                            = module.nms_common.nms_cloud_init.rendered
  tags = {
    Name = "nms_example"
  }
}

resource "aws_security_group" "nms-secgroup" {
  name   = "nms-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "nms-secgroup"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.incoming_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.incoming_cidr_blocks
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  timeouts {
    create = "2m"
  }
}
