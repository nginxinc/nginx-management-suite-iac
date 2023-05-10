variable "host_default_user" {
  description = "Default user for host"
  type        = string
}

variable "ssh_pub_key" {
  description = "Path to ssh key for access to host"
  type        = string
}

variable "acm_host_ip" {
  description = "Name of the instance group to use for the agent"
  type        = string
}

variable "instance_group_name" {
  description = "Name of the instance group to use for the agent"
  type        = string
}