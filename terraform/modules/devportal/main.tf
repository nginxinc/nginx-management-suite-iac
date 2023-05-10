data "local_file" "ssh_pub_file" { 
  depends_on = [
    var.ssh_pub_key
  ]
  filename = pathexpand(var.ssh_pub_key)
}

data "local_file" "db_ca_cert_file" {
  count = var.db_ca_cert_file != null ? 1 : 0
  filename = pathexpand(var.db_ca_cert_file)
}

data "local_file" "db_client_cert_file" {
  count = var.db_client_cert_file != null ? 1 : 0
  filename = pathexpand(var.db_client_cert_file)
}

data "local_file" "db_client_key_file" {
  count = var.db_client_key_file != null ? 1 : 0
  filename = pathexpand(var.db_client_key_file)
}

data "template_cloudinit_config" "cloud_init" {
  depends_on = [
    data.local_file.ssh_pub_file,
    data.local_file.db_ca_cert_file,
    data.local_file.db_client_cert_file,
    data.local_file.db_client_key_file,
  ]
  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud_init.tmpl", {
      default_user            = var.host_default_user
      public_key              = data.local_file.ssh_pub_file.content
      db_type                 = var.db_type
      db_host                 = var.db_host
      db_user                 = var.db_user
      db_password             = var.db_password
      db_ca_cert_file         = var.db_ca_cert_file != null ? data.local_file.db_ca_cert_file[0].content_base64 : ""
      db_client_cert_file     = var.db_client_cert_file != null ? data.local_file.db_client_cert_file[0].content_base64 : ""
      db_client_key_file      = var.db_client_key_file != null ? data.local_file.db_client_key_file[0].content_base64 : ""
      acm_host_ip             = var.acm_host_ip != null ? var.acm_host_ip : ""
      instance_group_name     = var.instance_group_name != null ? var.instance_group_name : ""
      ip_address              = var.ip_address != null ? var.ip_address: ""
      zone                    = var.zone != null ? var.zone: ""
    })
  }
}
