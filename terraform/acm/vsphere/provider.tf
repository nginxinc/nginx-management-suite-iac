/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

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

