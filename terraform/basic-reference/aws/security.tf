/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

resource "tls_private_key" "nms" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "nms" {
  private_key_pem = tls_private_key.nms.private_key_pem


  subject {
    common_name  = module.nms_alb.lb_dns_name
  }

  validity_period_hours = 12

  allowed_uses = [
    "server_auth",
  ]
}

resource "aws_acm_certificate" "nms" {
  private_key      = tls_private_key.nms.private_key_pem
  certificate_body = tls_self_signed_cert.nms.cert_pem
}

resource "aws_security_group" "nms_alb_secgroup" {
  name   = "nms-alb-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "nms-alb-secgroup"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.mgmt_cidr_blocks, formatlist("%s/32", module.vpc.nat_public_ips))
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

resource "aws_security_group" "nms_secgroup" {
  name   = "nms-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "nms-secgroup"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion_example.private_ip}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.mgmt_cidr_blocks, [module.vpc.vpc_cidr_block], formatlist("%s/32", module.vpc.nat_public_ips))
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

resource "aws_security_group" "bastion_secgroup" {
  name   = "bastion-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "bastion-secgroup"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.mgmt_cidr_blocks
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

resource "aws_security_group" "agent_secgroup" {
  name   = "agent-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "agent-secgroup"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion_example.private_ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat([module.vpc.vpc_cidr_block],var.dataplane_cidr_blocks)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat([module.vpc.vpc_cidr_block],var.dataplane_cidr_blocks)
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
