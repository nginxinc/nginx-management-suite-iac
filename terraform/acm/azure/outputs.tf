/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

output acm_host_ip {
  value       = azurerm_public_ip.example.ip_address
  description = "IP for NMS API Connectivity Manager control host"
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${azurerm_public_ip.example.ip_address}"
}

output "acm_endpoint" {
  description = "URL for NMS API Connectivity Manager control host"
  value       = "https://${azurerm_public_ip.example.ip_address}"
}
