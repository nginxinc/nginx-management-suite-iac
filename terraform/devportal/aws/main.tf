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
  public_ip_file       = "${path.module}/public_ip"
}

module "vpc" {
  count  = var.subnet_id != null ? 0 : 1
  source = "terraform-aws-modules/vpc/aws"

  name = "devportal-vpc"
  cidr = "10.0.0.0/16"

  azs            = [random_shuffle.random_az.result[0]]
  public_subnets = ["10.0.101.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "common" {
  source                = "../../modules/devportal"
  db_ca_cert_file       = var.db_ca_cert_file
  db_client_cert_file   = var.db_client_cert_file
  db_client_key_file    = var.db_client_key_file
  db_host               = var.db_host
  db_user               = var.db_user
  db_password           = var.db_password
  db_type               = var.db_type
  host_default_user     = var.ssh_user
  ssh_pub_key           = var.ssh_pub_key
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

resource "aws_instance" "devportal_example" {
  ami                                  = var.ami_id
  instance_type                        = var.instance_type
  vpc_security_group_ids               = [aws_security_group.devportal_secgroup.id]
  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "terminate"
  subnet_id                            = local.subnet_id
  tags = {
    Name = "devportal-example"
  }
  user_data = module.common.cloud_init.rendered
}

resource "aws_security_group" "devportal_secgroup" {
  name   = "devportal-secgroup"
  vpc_id = local.vpc_id
  tags = {
    Name = "devportal-secgroup"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.incoming_cidr_blocks != null ? concat(var.incoming_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
    self        = true
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = var.incoming_cidr_blocks != null ? concat(var.incoming_cidr_blocks, ["${chomp(data.local_file.my_public_ip.content)}/32"]) : ["${chomp(data.local_file.my_public_ip.content)}/32"]
    self        = true
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

resource "null_resource" "example" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.devportal_example.public_ip
      user = var.ssh_user
      private_key = file(pathexpand(var.ssh_private_key))
    }

    inline = ["echo 'connected!'"]
  }
}