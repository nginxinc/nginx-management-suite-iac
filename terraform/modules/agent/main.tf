data "local_file" "ssh_pub_file" {
  depends_on = [
    var.ssh_pub_key
  ]
  filename = pathexpand(var.ssh_pub_key)
}

data "template_cloudinit_config" "agent_cloud_init" {
  depends_on = [
    data.local_file.ssh_pub_file
  ]

  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/agent_cloud_init.tmpl", {
      default_user        = var.host_default_user
      public_key          = data.local_file.ssh_pub_file.content
      nms_host_ip         = var.nms_host_ip
      instance_group_name = var.instance_group_name
    })
  }
}
