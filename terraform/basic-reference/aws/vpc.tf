/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "nms_vpc"
  cidr = "10.0.0.0/16"

  azs             = [random_shuffle.random_az.result[0]]
  public_subnets  = [local.public_subnet_cidr_block]
  private_subnets = [local.controlplane_subnet_cidr_blocks, local.dataplane_subnet_cidr_blocks]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


data "aws_availability_zones" "available_zones" {
  state         = "available"
  exclude_names = ["us-west-2d"]
}

resource "random_shuffle" "random_az" {
  input = data.aws_availability_zones.available_zones.names
}
