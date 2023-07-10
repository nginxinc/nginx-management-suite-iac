output "nms_cloud_init" {
  value = data.template_cloudinit_config.nms_cloud_init
}

output "htpasswd_data" {
  value = data.local_file.htpasswd_file
}
