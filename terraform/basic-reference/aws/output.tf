output "acm_endpoint" {
  description = "URL for NMS API Connectivity Manager control host"
  value       = "https://${aws_instance.acm_example.public_ip}"
}

output "acm_host_ip" {
  description = "IP for NMS API Connectivity Manager control host"
  value       = aws_instance.acm_example.public_ip
}

output acm_ssh_command {
  value = "ssh ${var.ssh_user}@${aws_instance.acm_example.public_ip}"
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

