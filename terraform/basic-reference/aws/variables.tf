/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "admin_password" {
  description = "The password associated with the admin user"
  type        = string
  sensitive   = true
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "user account to log in."
}

variable "ssh_pub_key" {
  description = "Path to ssh key for access to host."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "license_file_path" {
  description = "Path to the NGINX Management Suite license file."
  type        = string
}

variable "dataplane_cidr_blocks" {
  description = "List of cidr blocks (used to allow inbound access to Dataplane instances)."
  type        = list(string)
  default     = []
}

variable "mgmt_cidr_blocks" {
  description = "List of cidr blocks used for remote management of instances."
  type        = list(string)
  default     = []
}

variable "nms_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}


variable "nginx_instance_type" {
  type    = string
  default = "t3.micro"
}


variable "nms_ami_id" {
  description = "NGINX Management Suite AMI being deployed."
  type        = string
}

variable "nginx_ami_id" {
  description = "NGINX AMI being deployed."
  type        = string
}

variable "aws_region" {
  description = "Region of where to deploy the instance."
  type        = string
  default     = "us-west-1"
}

variable "agent_instance_group_name" {
  description = "Name of the instance group / cluster to subscribe the agents to."
  type        = string
}

variable "agent_count" {
  type        = number
  default     = 1
  description = "The amount of agents you would like to deploy"
}

variable "disk_config" {
  type        = map
  description = "Map of size and device paths for attached storage"
  default     = {
    "dqlite": {
      "size": 20,
      "block_device": "/dev/xvdh"
    }
    "secrets": {
      "size": 1,
      "block_device": "/dev/xvdi"
    }
    "streaming": {
      "size": 1,
      "block_device": "/dev/xvdj"
    },
    "ssl": {
      "size": 1,
      "block_device": "/dev/xvdk"
    },
    "clickhouse": {
      "size": 20,
      "block_device": "/dev/xvdl"
    }
  }
}

variable "tags" {
  type        = map
  default     = {}
  description = "Map of tags to apply to resulting AWS resources"
}
