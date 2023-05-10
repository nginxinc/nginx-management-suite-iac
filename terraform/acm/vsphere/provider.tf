# az cli needed

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">=2.2.0"
    }
  }
}

provider "vsphere" {
    vsphere_server = var.vsphere_url
    user = var.vsphere_username
    password = var.vsphere_password
    allow_unverified_ssl = true
}

