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

resource "random_shuffle" "random_az" {
  input = data.aws_availability_zones.available_zones.names
}

locals {
  vpc_id                          = module.vpc.vpc_id
  controlplane_subnet_id          = module.vpc.public_subnets[0]
  controlplane_subnet_cidr_blocks = "10.0.101.0/24"
  dataplane_subnet_cidr_blocks    = "10.0.102.0/24"
  dataplane_cidr_blocks           = var.dataplane_cidr_blocks != null ? concat(var.dataplane_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  mgmt_cidr_blocks                = var.mgmt_cidr_blocks != null ? concat(var.mgmt_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
  dataplane_subnet_id             = module.vpc.public_subnets[1]
  public_ip_file                  = "${path.module}/public_ip"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "acm_vpc"
  cidr = "10.0.0.0/16"

  azs            = [random_shuffle.random_az.result[0]]
  public_subnets = [local.controlplane_subnet_cidr_blocks, local.dataplane_subnet_cidr_blocks]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "acm_common" {
  source            = "../../modules/acm"
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
  acm_host_ip         = aws_instance.acm_example.public_ip
  instance_group_name = var.agent_instance_group_name
  ssh_pub_key         = pathexpand(var.ssh_pub_key)

  depends_on = [
    aws_instance.acm_example
  ]
}

module "devportal_common" {
  source                = "../../modules/devportal"
  host_default_user     = var.ssh_user
  acm_host_ip           = aws_instance.acm_example.public_ip
  instance_group_name   = var.devportal_instance_group_name
  ssh_pub_key           = pathexpand(var.ssh_pub_key)
  db_ca_cert_file       = var.devportal_db_ca_cert_file
  db_client_cert_file   = var.devportal_db_client_cert_file
  db_client_key_file    = var.devportal_db_client_key_file
  db_host               = var.devportal_db_host
  db_user               = var.devportal_db_user
  db_password           = var.devportal_db_password
  db_type               = var.devportal_db_type
  ip_address            = aws_eip.devportal_eip.public_ip
  zone                  = var.devportal_zone

  depends_on = [
    aws_instance.acm_example
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

resource "aws_eip" "devportal_eip" {
  vpc      = true
}


resource "aws_eip" "agent_eip" {
  vpc      = true
  count = var.agent_count
}

resource "aws_eip_association" "agent_eip_assoc" {
  count         = var.agent_count
  instance_id   = aws_instance.agent_example[count.index].id
  allocation_id = aws_eip.agent_eip[count.index].id
}

resource "aws_eip_association" "devportal_eip_assoc" {
  instance_id   = aws_instance.devportal_example.id
  allocation_id = aws_eip.devportal_eip.id
}



resource "aws_instance" "acm_example" {
  ami                                  = var.acm_ami_id
  instance_type                        = var.acm_instance_type
  vpc_security_group_ids               = [aws_security_group.acm_secgroup.id]
  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.controlplane_subnet_id
  tags = {
    Name = "acm_example"
  }
  user_data = module.acm_common.acm_cloud_init.rendered
}

resource "aws_instance" "agent_example" {
  depends_on = [
    null_resource.acm_connection
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
    null_resource.acm_connection
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

resource "aws_security_group" "acm_secgroup" {
  name   = "acm-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "acm-secgroup"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.mgmt_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(local.mgmt_cidr_blocks, [for eip in aws_eip.agent_eip : "${eip.public_ip}/32"], [ "${aws_eip.devportal_eip.public_ip}/32"] )
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
    cidr_blocks = local.mgmt_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.dataplane_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.dataplane_cidr_blocks
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
    cidr_blocks = local.mgmt_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.dataplane_cidr_blocks
  }

  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.acm_example.public_ip}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.dataplane_cidr_blocks
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



resource "null_resource" "acm_connection" {
  depends_on = [
    aws_instance.acm_example
  ]
  provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_instance.acm_example.public_ip} ${pathexpand(var.ssh_private_key)} && bash ../scripts/license_apply.sh https://${aws_instance.acm_example.public_ip} ${var.license_file_path} ${var.admin_user} ${var.admin_passwd}"
  }
}

resource "null_resource" "agent_connection" {
    depends_on = [
      aws_instance.agent_example
    ]

    count = var.agent_count
    provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_eip.agent_eip[count.index].public_ip} ${pathexpand(var.ssh_private_key)}"
  }
}


resource "null_resource" "devportal_connection" {
  depends_on = [
    aws_instance.devportal_example
  ]
  provisioner "local-exec" {
    command = "bash ../scripts/ssh_check.sh ${var.ssh_user} ${aws_eip.devportal_eip.public_ip} ${pathexpand(var.ssh_private_key)}"
  }
}