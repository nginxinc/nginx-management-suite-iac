/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

locals {
  vpc_id                          = module.vpc.vpc_id
  controlplane_subnet_cidr_blocks = "10.0.101.0/24"
  dataplane_subnet_cidr_blocks    = "10.0.102.0/24"
  public_subnet_cidr_blocks        = ["10.0.103.0/24", "10.0.104.0/24"]
  dataplane_cidr_blocks           = var.dataplane_cidr_blocks != null ? concat(var.dataplane_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  mgmt_cidr_blocks                = var.mgmt_cidr_blocks != null ? concat(var.mgmt_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  public_subnet_id                = module.vpc.public_subnets[0]
  controlplane_subnet_id          = module.vpc.private_subnets[0]
  dataplane_subnet_id             = module.vpc.private_subnets[1]
  public_ip_file                  = "${path.module}/public_ip"
}




resource "null_resource" "apply_nms_license" {
  depends_on = [
    module.nms_alb,
    aws_instance.bastion_example
  ]

  provisioner "local-exec" {
    command = "bash ../scripts/license_apply.sh https://${module.nms_alb.lb_dns_name} ${var.license_file_path} ${var.admin_user} ${var.admin_passwd}"
  }
 }
 