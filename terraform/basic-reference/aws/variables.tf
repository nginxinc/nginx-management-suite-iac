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

variable "admin_passwd" {
  description = "The password associated with the admin user"
  type        = string
  sensitive = true
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

variable "ssh_private_key" {
  description = "Path to ssh key for access to host."
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "license_file_path" {
  description = "Path to the NGINX API Connectivity Manager license file."
  type        = string
}

variable "dataplane_cidr_blocks" {
  description = "List of cidr blocks (used to allow inbound access to Dataplane instances)."
  type        = list(string)
  default     = null
}

variable "mgmt_cidr_blocks" {
  description = "List of cidr blocks used for remote management of instances."
  type        = list(string)
  default     = null
}

variable "acm_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "agent_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "devportal_instance_type" {
  type    = string
  default = "t3.medium"
  description = "Size of the devportal instance. A minimum of a t3.medium size instance is required if using an embedded pg instance."
}

variable "acm_ami_id" {
  description = "API Connectivity Manager AMI being deployed."
  type        = string
}

variable "agent_ami_id" {
  description = "NGINX Agent AMI being deployed."
  type        = string
}

variable "devportal_ami_id" {
  description = "NGINX Devportal AMI being deployed."
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

variable "devportal_instance_group_name"{
  description = "Name of the instance group / cluster to subscribe the agents to."
  type        = string
}

variable "devportal_db_type" {
  description = "Type of database. Either psql or sqlite."
  type        = string
  default = "psql"

  validation {
    condition     =  contains(["psql", "sqlite"], var.devportal_db_type)
    error_message = "Allowed values for devportal_db_type are \"psql\" or \"sqlite\"."
  }
}

variable "devportal_db_user" {
  type = string
  description = "NGINX db user"
  default = "nginx-devportal" 
}

variable "devportal_db_password" {
  type = string
  description = "NGINX db password"
  default     = "nginx-devportal"
  sensitive = true
}

variable "devportal_db_host" {
  type = string
  default = "/var/run/postgresql"
  description = "NGINX db hostname"
}

variable "devportal_db_ca_cert_file" {
  type = string
  default = null
  description = "CA Cert"
}

variable "devportal_db_client_cert_file" {
  type = string
  default = null
  description = "Client Cert"
}

variable "devportal_db_client_key_file" {
  type = string
  default = null
  description = "Client Key file"
}

variable "devportal_zone" {
  type = string
  default = "devportal.example.com"
  description = "The zone that the devportal will be configured using."
}

variable "agent_count" {
  type = number
  default = 1
  description = "The amount of agents you would like to deploy"
}
