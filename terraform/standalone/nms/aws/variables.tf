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
}

variable ssh_user {
    type = string
    default = "ubuntu"
    description = "user account to log in."
}

variable "ssh_pub_key" {
  description = "Path to ssh key for access to host."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "incoming_cidr_blocks" {
  description = "List of cidr blocks (used to allow inbound access in public cloud)."
  type        = list(string)
  default     = null
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  description = "AMI being deployed."
  type        = string
}

variable "aws_region" {
  description = "Region of where to deploy the instance."
  type        = string
  default     = "us-west-1"
}

variable "subnet_id" {
  description = "ID of subnet to use for this instance. If unset, then a new vpc & subnet will be created."
  type        = string
  default     = null
}
