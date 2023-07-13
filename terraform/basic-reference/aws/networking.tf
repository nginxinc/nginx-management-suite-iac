/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */


module "nms-nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "nms-nlb"

  load_balancer_type = "network"

  vpc_id  = module.vpc.vpc_id

  subnet_mapping = [{
    subnet_id = local.public_subnet_id
    allocation_id = aws_eip.nms_eip.id
  }]

  target_groups = [
    {
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "instance"

      targets = {
        my_target = {
        target_id = aws_instance.nms_example.id
        port = 443
        }
      }
   }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = aws_acm_certificate.nms.arn

    }
  ]

  tags = {
    Environment = "NMS"
  }
}

module "agents-nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "agents-nlb"

  load_balancer_type = "network"

  vpc_id  = module.vpc.vpc_id

  subnet_mapping = [{
        subnet_id = local.public_subnet_id
        allocation_id = aws_eip.agent_eip.id
  }]

  http_tcp_listeners = [{
      port               = 80,
      protocol           = "TCP"
    }
  ]

  target_groups = [
   {
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"

      targets = {
        for idx, target_instance in aws_instance.agent_example :
           "target-${idx + 1}" => {
            target_id = target_instance.id
            port      = 80
          }
      }
   }
  ]

  tags = {
    Environment = "Agents"
  }
}

resource "null_resource" "get_my_public_ip" {
  provisioner "local-exec" {
    command = "curl -sSf https://checkip.amazonaws.com > ${local.public_ip_file}"
  }
}

data "local_file" "my_public_ip" {
  depends_on = [null_resource.get_my_public_ip]
  filename   = local.public_ip_file
}

resource "aws_eip" "nms_eip" {
  vpc = true
}



resource "aws_eip" "agent_eip" {
  vpc   = true
}
