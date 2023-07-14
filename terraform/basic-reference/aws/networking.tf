/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */


module "nms_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "nms-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id

  subnets = module.vpc.public_subnets

  security_groups = [ aws_security_group.nms_alb_secgroup.id ]

  target_groups = [
    {
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      protocol_version = "HTTP2"

      health_check    = {
        healthy_threshold = 2
        interval          = 10
        matcher           = "302"
        protocol          = "HTTPS"
      }

      targets = {
        my_target = {
        target_id = aws_instance.nms_example.id
        port = 443
        }
      }
   },
   {
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      protocol_version = "HTTP1"
      path             = "/packages-repository"

      health_check    = {
        healthy_threshold = 2
        interval          = 10
        matcher           = "302"
        protocol          = "HTTPS"
      }

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
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate.nms.arn
    }
  ]

  https_listener_rules = [{
      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]

      conditions = [{
        path_patterns = ["/packages-repository/*"]
      }]
    }
   ]
  

  tags = {
    Environment = "NMS"
  }
}

module "agents_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "agents-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id

  subnets = module.vpc.public_subnets

  http_tcp_listeners = [{
      port               = 80,
      protocol           = "HTTP"
    }
  ]

  target_groups = [
   {
      backend_protocol = "HTTP"
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

