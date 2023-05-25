
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

variable admin_user {
  description = "The name of the admin user"
  type        = string
  default     = "admin"
}

variable admin_passwd {
  description = "The password associated with the admin user"
  type        = string
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
