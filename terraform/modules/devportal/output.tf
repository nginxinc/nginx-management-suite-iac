output "cloud_init" {
  value = data.template_cloudinit_config.cloud_init
}
