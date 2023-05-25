/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

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

variable template_name {
  description = "Name of the ACM VM Template"
  type        = string
}


variable cluster_name {
  description = "vSphere Cluster to deploy into"
  type        = string
}

variable datacenter {
  description = "vSphere Datacenter to use"
  type        = string
}

variable datastore {
  description = "vSphere Datastore use"
  type        = string
}

variable network {
  description = "vSphere Network to use"
  type        = string
}

variable vsphere_url {
  description = "vSphere template name to use"
  type        = string
}

variable vsphere_username {
  description = "vSphere username"
  type        = string
}

variable vsphere_password {
  description = "vSphere password"
  type        = string
  sensitive = true
}

variable "db_user" {
  type = string
  description = "NGINX db user"
  default = "nginx-devportal"
}

variable "db_password" {
  type = string
  description = "NGINX db password"
  default = "nginx-devportal"
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

variable "db_type" {
  description = "Type of database. Either psql or sqlite."
  type        = string
  default = "psql"

  validation {
    condition     =  contains(["psql", "sqlite"], var.db_type)
    error_message = "Allowed values for db_type are \"psql\" or \"sqlite\"."
  }
}
