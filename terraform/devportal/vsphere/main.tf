/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "nginx-devportal-machine"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  extra_config = {
    "guestinfo.metadata" = base64encode(
      templatefile(
        "${path.module}/cloud-init/metadata.tmpl",
        {
          host_name = "example"
        }
      )
    )
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode(
      templatefile(
        "${path.module}/cloud-init/userdata.tmpl",
        {
          default_user       = var.ssh_user
          public_key         = file(pathexpand(var.ssh_pub_key))
          host_name          = "example"
          domain             = "local"
          db_type              = var.db_type
          db_host              = var.db_host
          db_user              = var.db_user
          db_password          = var.db_password
          db_ca_cert_file      = var.db_ca_cert_file != null ? file(pathexpand(var.db_ca_cert_file)): ""
          db_client_cert_file  = var.db_client_cert_file != null ? file(pathexpand(var.db_client_cert_file)) : ""
          db_client_key_file   = var.db_client_key_file != null ? file(pathexpand(var.db_client_key_file)): ""
        }
      )
    )
    "guestinfo.userdata.encoding" = "base64"

  }
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
