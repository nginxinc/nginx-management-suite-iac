/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

variable resource_group_name {
  type        = string
  description = "The Azure resource group to use."
}

variable ssh_user {
    type = string
    default = "ubuntu"
    description = "user account to log in"
}

variable ssh_pub_key {
    type = string
    default = "~/.ssh/id_rsa.pub"
    description = "ssh public key for access"
}

variable "admin_password" {
  description = "The password associated with the admin user"
  type        = string
}

variable "incoming_cidr_blocks" {
  description = "List of cidr blocks (used to allow inbound access in public cloud)."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  type    = string
  default = "Standard_B2s"
}

variable "image_name" {
  description = "Image being deployed"
  type        = string
}

variable "tags" {
  type        = map
  default     = {}
  description = "Map of tags to apply to resulting Azure resources"
}
