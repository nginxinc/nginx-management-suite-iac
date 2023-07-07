/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

output nms_host_ip {
  value       = vsphere_virtual_machine.vm.default_ip_address
  description = "IP for NMS control host"
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${vsphere_virtual_machine.vm.default_ip_address}"
}

output "nms_endpoint" {
  description = "URL for NMS control host"
  value       = "https://${vsphere_virtual_machine.vm.default_ip_address}"
}
