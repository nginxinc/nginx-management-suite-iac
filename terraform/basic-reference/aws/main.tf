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
      version = "~> 4.16"
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

resource "tls_private_key" "nms" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "nms" {
  private_key_pem = tls_private_key.nms.private_key_pem


  subject {
    common_name  = aws_eip.nms_eip.public_ip
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

module "devportal-nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "devportal-nlb"

  load_balancer_type = "network"

  vpc_id  = module.vpc.vpc_id

  subnet_mapping = [{
    subnet_id = local.public_subnet_id
    allocation_id = aws_eip.devportal_eip.id
  }]

  http_tcp_listeners = [{
      port               = 80,
      protocol           = "TCP"
    },
    {
      port               = 81,
      protocol           = "TCP"
    }
  ]

  target_groups = [
   {
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"

      targets = {
        my_target = {
        target_id = aws_instance.devportal_example.id
        port = 80
        }
      }
   },
   {
      backend_protocol = "TCP"
      backend_port     = 81
      target_type      = "instance"

      targets = {
        my_target = {
        target_id = aws_instance.devportal_example.id
        port = 81
        }
      }
   }
  ]

  tags = {
    Environment = "Devportal"
  }
}

resource "random_shuffle" "random_az" {
  input = data.aws_availability_zones.available_zones.names
}

locals {
  vpc_id                          = module.vpc.vpc_id
  controlplane_subnet_cidr_blocks = "10.0.101.0/24"
  dataplane_subnet_cidr_blocks    = "10.0.102.0/24"
  public_subnet_cidr_block        = "10.0.103.0/24"
  dataplane_cidr_blocks           = var.dataplane_cidr_blocks != null ? concat(var.dataplane_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  mgmt_cidr_blocks                = var.mgmt_cidr_blocks != null ? concat(var.mgmt_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  public_subnet_id               = module.vpc.public_subnets[0]
  controlplane_subnet_id          = module.vpc.private_subnets[0]
  dataplane_subnet_id             = module.vpc.private_subnets[1]
  public_ip_file                  = "${path.module}/public_ip"
}

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

module "nms_common" {
  source            = "../../modules/nms"
  admin_user        = var.admin_user
  admin_passwd      = var.admin_passwd
  host_default_user = var.ssh_user
  devportal_ip      = aws_eip.devportal_eip.public_ip
  devportal_zone    = var.devportal_zone
  ssh_pub_key       = pathexpand(var.ssh_pub_key)
}

module "agent_common" {
  source              = "../../modules/agent"
  host_default_user   = var.ssh_user
  nms_host_ip         = aws_eip.nms_eip.public_ip
  instance_group_name = var.agent_instance_group_name
  ssh_pub_key         = pathexpand(var.ssh_pub_key)

  depends_on = [
    null_resource.bastion_nms_connection
  ]
}

module "devportal_common" {
  source              = "../../modules/devportal"
  host_default_user   = var.ssh_user
  nms_host_ip         = aws_eip.nms_eip.public_ip
  instance_group_name = var.devportal_instance_group_name
  ssh_pub_key         = pathexpand(var.ssh_pub_key)
  db_ca_cert_file     = var.devportal_db_ca_cert_file
  db_client_cert_file = var.devportal_db_client_cert_file
  db_client_key_file  = var.devportal_db_client_key_file
  db_host             = var.devportal_db_host
  db_user             = var.devportal_db_user
  db_password         = var.devportal_db_password
  db_type             = var.devportal_db_type
  ip_address          = aws_eip.devportal_eip.public_ip
  zone                = var.devportal_zone

  depends_on = [
    null_resource.bastion_nms_connection
  ]
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


resource "aws_eip" "devportal_eip" {
  vpc = true
}

resource "aws_eip" "agent_eip" {
  vpc   = true
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

resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion-key-pair"
  public_key = file(pathexpand(var.ssh_pub_key))
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
    null_resource.bastion_nms_connection
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

resource "aws_instance" "devportal_example" {
  depends_on = [
    null_resource.bastion_nms_connection
  ]
  ami                                  = var.devportal_ami_id
  instance_type                        = var.devportal_instance_type
  vpc_security_group_ids               = [aws_security_group.devportal_secgroup.id]
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.dataplane_subnet_id
  tags = {
    Name = "devportal_example"
  }
  user_data = module.devportal_common.cloud_init.rendered
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
    cidr_blocks = concat(local.mgmt_cidr_blocks, [module.vpc.vpc_cidr_block], ["${module.vpc.nat_public_ips[0]}/32"])
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
    cidr_blocks = local.mgmt_cidr_blocks
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
    cidr_blocks = concat([module.vpc.vpc_cidr_block],local.dataplane_cidr_blocks)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat([module.vpc.vpc_cidr_block],local.dataplane_cidr_blocks)
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

resource "aws_security_group" "devportal_secgroup" {
  name   = "devportal-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "devportal-secgroup"
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
    cidr_blocks = concat([module.vpc.vpc_cidr_block],local.dataplane_cidr_blocks)
  }

  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = concat([module.vpc.vpc_cidr_block],["${aws_eip.nms_eip.public_ip}/32"])
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat([module.vpc.vpc_cidr_block],local.dataplane_cidr_blocks)
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



resource "null_resource" "bastion_nms_connection" {
  depends_on = [
    module.nms-nlb,
    aws_instance.bastion_example
  ]

  provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_instance.bastion_example.public_ip} ${aws_instance.nms_example.private_ip} ${pathexpand(var.ssh_private_key)} && bash ../scripts/license_apply.sh https://${aws_eip.nms_eip.public_ip} ${var.license_file_path} ${var.admin_user} ${var.admin_passwd}"
  }
}

# Temporary workaround. To be deleted.
resource "null_resource" "adm_restart" {
  depends_on = [
    null_resource.bastion_nms_connection
  ]
  provisioner "local-exec" {
    command = "bash ../scripts/restart_adm.sh ${var.ssh_user} ${aws_instance.bastion_example.public_ip} ${aws_instance.nms_example.private_ip} ${pathexpand(var.ssh_private_key)}"
  }
}

resource "null_resource" "agent_connection" {
  depends_on = [
    aws_instance.agent_example
  ]

  count = var.agent_count
  provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_instance.bastion_example.public_ip} ${aws_instance.agent_example[count.index].private_ip} ${pathexpand(var.ssh_private_key)}"
  }
}

resource "null_resource" "devportal_connection" {
  depends_on = [
    aws_instance.devportal_example
  ]
  provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_instance.bastion_example.public_ip} ${aws_instance.devportal_example.private_ip} ${pathexpand(var.ssh_private_key)}"
  }
}
