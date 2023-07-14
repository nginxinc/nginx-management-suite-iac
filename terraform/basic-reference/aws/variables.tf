/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "admin_user" {
  description = "The name of the admin user"
  type        = string
  default     = "admin"
}

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

variable "ssh_private_key" {
  description = "Path to ssh key for access to host."
  type        = string
  default     = "~/.ssh/id_rsa"
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
  default = "t3.medium"
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}


variable "agent_instance_type" {
  type    = string
  default = "t3.micro"
}


variable "nms_ami_id" {
  description = "NGINX Management Suite AMI being deployed."
  type        = string
}

variable "agent_ami_id" {
  description = "NGINX Agent AMI being deployed."
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
