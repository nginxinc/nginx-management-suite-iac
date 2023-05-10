output devportal_host_ip {
  value       = azurerm_public_ip.example.ip_address
  description = "IP for NMS API Connectivity Manager control host"
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${azurerm_public_ip.example.ip_address}"
}
