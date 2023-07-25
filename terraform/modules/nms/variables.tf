variable "admin_password" {
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

variable "disks" {
  description = "String concatanated list of disks to be mounted e.g 'mount_path:device_path mount_path:device_path'"
  type        = string
}