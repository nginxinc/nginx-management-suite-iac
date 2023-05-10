output "agent_cloud_init" {
  value = data.template_cloudinit_config.agent_cloud_init
}
