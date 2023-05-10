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
  default = "t3.medium"
  description = "The size of the AWS Instance. When deploying with an embedded database the minimum instance size is medium with a t3 architecture."
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


variable "db_type" {
  description = "Type of database. Either psql or sqlite."
  type        = string
  default = "psql"

  validation {
    condition     =  contains(["psql", "sqlite"], var.db_type)
    error_message = "Allowed values for db_type are \"psql\" or \"sqlite\"."
  }
}

variable "db_user" {
  type = string
  description = "NGINX db user"
  default = "nginx-devportal"
}

variable "db_password" {
  type = string
  description = "NGINX db password"
  default     = "complexPassword1*"
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

variable "ssh_private_key" {
  description = "Path to ssh key for access to host."
  type        = string
  sensitive = true
  default     = "~/.ssh/id_rsa"
}
