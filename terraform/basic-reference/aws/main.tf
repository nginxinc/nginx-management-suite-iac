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
  public_subnet_cidr_blocks       = ["10.0.103.0/24", "10.0.104.0/24"]
  public_subnet_id                = module.vpc.public_subnets[0]
  controlplane_subnet_id          = module.vpc.private_subnets[0]
  dataplane_subnet_id             = module.vpc.private_subnets[1]
  disks                           = [
    {
      "name": "dqlite",
      "device": var.disk_config.dqlite.block_device,
      "size": var.disk_config.dqlite.size,
      "mount": "/var/lib/nms/dqlite"
    },
    {
      "name": "secrets",
      "device": var.disk_config.secrets.block_device,
      "size": var.disk_config.secrets.size,
      "mount": "/var/lib/nms/secrets"
    },
    {
      "name": "streaming",
      "device": var.disk_config.streaming.block_device,
      "size": var.disk_config.streaming.size,
      "mount": "/var/lib/nms/streaming"
    },
    {
      "name": "ssl",
      "device": var.disk_config.ssl.block_device,
      "size": var.disk_config.ssl.size,
      "mount": "/etc/nms/certs"
    }
  ]
  device_list                     = join(" ", [for s in local.disks : "${s.mount}:${s.device}"])
}

resource "null_resource" "apply_nms_license" {
  depends_on = [
    module.nms_alb,
    aws_instance.nms_example
  ]

  provisioner "local-exec" {
    command = "bash ../scripts/license_apply.sh https://${module.nms_alb.lb_dns_name} ${var.license_file_path} admin ${var.admin_password}"
  }
 }
 