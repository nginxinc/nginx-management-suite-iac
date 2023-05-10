output "acm_cloud_init" {
  value = data.template_cloudinit_config.acm_cloud_init
}

output "htpasswd_data" {
  value = data.local_file.htpasswd_file
}
