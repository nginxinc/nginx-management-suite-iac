variable "admin_user" {
  description = "The name of the admin user"
  type        = string
  default     = "admin"
}

variable "admin_passwd" {
  description = "The password associated with the admin user"
  type        = string
  sensitive   = true
}

variable "host_default_user" {
  description = "Default user for host"
  type        = string
}

variable "ssh_pub_key" {
  description = "Path to ssh key for access to host"
  type        = string
}

variable "devportal_ip" {
  description = "IP address of the devportal."
  type        = string
  default    = null
}

variable "devportal_zone" {
  description = "Name of the zone that the devportal is on. "
  type        = string
  default    = null
}