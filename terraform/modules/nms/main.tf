resource "null_resource" "make_htpasswd_file" {
  depends_on = [
    var.admin_user, var.admin_passwd
  ]
  provisioner "local-exec" {
    command = "htpasswd -c -b ${path.cwd}/.nms_htpasswd ${var.admin_user} '${var.admin_passwd}'"
    when    = create
  }
}

data "local_file" "htpasswd_file" {
  depends_on = [
    null_resource.make_htpasswd_file
  ]
  filename = "${path.cwd}/.nms_htpasswd"
}

data "local_file" "ssh_pub_file" {
  depends_on = [
    var.ssh_pub_key
  ]
  filename = pathexpand(var.ssh_pub_key)
}

data "template_cloudinit_config" "nms_cloud_init" {
  depends_on = [
    data.local_file.ssh_pub_file,
    data.local_file.htpasswd_file
  ]

  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/nms_cloud_init.tmpl", {
      default_user   = var.host_default_user
      public_key     = data.local_file.ssh_pub_file.content
      htpasswd_file  = data.local_file.htpasswd_file.content
    })
  }
}
