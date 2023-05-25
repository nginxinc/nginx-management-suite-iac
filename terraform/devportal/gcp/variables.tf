/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

variable region {
  type        = string
  description = "The GCP region to use."
  default = "europe-west4"
}

variable project_id {
  type        = string
  description = "The GCP project ID to use."
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
  default = "e2-small"
  description = "The size of the GCP Compute Instance."
}

variable "image_name" {
  description = "Image being deployed."
  type        = string
}

variable "db_type" {
  description = "Type of database. Either psql or sqlite."
  type        = string
  default     = "psql"

  validation {
    condition     = contains(["psql", "sqlite"], var.db_type)
    error_message = "Allowed values for db_type are \"psql\" or \"sqlite\"."
  }
}

variable "ssh_private_key" {
  description = "Path to ssh key for access to host."
  type        = string
  sensitive = true
  default     = "~/.ssh/id_rsa"
}

variable "db_user" {
  type = string
  description = "NGINX db user"
  default = "nginx-devportal"
}

variable "db_password" {
  type = string
  description = "NGINX db password"
  default = "complexPassword1*"
  sensitive = true
}

variable "db_host" {
  type = string
  default = "/var/run/postgresql"
  description = "NGINX db hostname"
}

variable "db_ca_cert_file" {
  type = string
  default = null
  description = "CA Cert"
}

variable "db_client_cert_file" {
  type = string
  default = null
  description = "Client Cert"
}

variable "db_client_key_file" {
  type = string
  default = null
  description = "Client Key file"
}
