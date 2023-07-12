/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

output "nms_endpoint" {
  description = "URL for NMS control host"
  value       = "https://${aws_instance.nms_example.public_ip}"
}

output "nms_host_ip" {
  description = "IP for NMS control host"
  value       = aws_instance.nms_example.private_ip
}

output nms_ssh_command {
  value = "ssh ${var.ssh_user}@${aws_instance.nms_example.public_ip}"
}

output "dataplane_agent_info" {
  description = "Agent information"
  value = {
    for index, eip in aws_eip.agent_eip : "dataplane-agent-${index + 1}" => {
      ip     = eip.public_ip
      ssh    = "ssh ${var.ssh_user}@${eip.public_ip}"
    }
  }
}

output "devportal_endpoint" {
  description = "IP for Devportal host"
  value       = "http://${aws_eip.devportal_eip.public_ip}/devportal"
}


output "devportal_host_ip" {
  description = "IP for Devportal host"
  value       = aws_eip.devportal_eip.public_ip
}

output devportal_ssh_command {
  value = "ssh ${var.ssh_user}@${aws_eip.devportal_eip.public_ip}"
}
