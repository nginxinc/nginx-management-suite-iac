/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

output "bastion_host" {
  description = "Bastion host"
  value       = aws_instance.bastion_example.public_ip
}

output "nms_endpoint" {
  description = "URL for NMS control host"
  value       = "https://${module.nms_alb.lb_dns_name}"
}

output "nms_host_ip" {
  description = "IP for NMS control host"
  value       = aws_instance.nms_example.private_ip
}

output nms_ssh_command {
  value = "ssh -J ${var.ssh_user}@${aws_instance.bastion_example.public_ip} ${var.ssh_user}@${aws_instance.nms_example.private_ip}"
}

output "dataplane_agent_info" {
  description = "Agent information"
  value = {
    for index, agent in aws_instance.agent_example : "dataplane-agent-${index + 1}" => {
      ip     = agent.private_ip
      ssh    = "ssh -J ${var.ssh_user}@${aws_instance.bastion_example.public_ip} ${var.ssh_user}@${agent.private_ip}"
    }
  }
}

output "agent_endpoint" {
  description = "Agent Endpoint"
  value = "http://${module.agents_alb.lb_dns_name}"
}
