variable "host_default_user" {
  description = "Default user for host"
  
  type        = string
}

variable "ssh_pub_key" {
  description = "Path to ssh key for access to host"
  type        = string
}

variable "db_type" {
  description = "Type of database. Either psql or sqlite."
  type        = string
  default     = "psql"
}

variable "db_host" {
  description = "Address of devportal database."
  type        = string
  default     = "/var/run/postgresql"
}

variable "db_user" {
  description = "User for devportal database."
  type        = string
  default     = "nginxdm"
}

variable "db_password" {
  description = "Password of user for devportal database."
  type        = string
  default     = "complexPassword1*"
  sensitive = true
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

variable "nms_host_ip" {
  description = "Host IP address of the NGINX Management Suite to install agent from"
  type        = string
  default    = null
}

variable "instance_group_name" {
  description = "Name of the instance group to use for the devportals agent"
  type        = string
  default    = null
}

variable "ip_address" {
  description = "IP that the instance will be hosted on."
  type        = string
  default    = null
}

variable "zone" {
  description = "Name of the zone to assign the devportal to."
  type        = string
  default    = null
}
