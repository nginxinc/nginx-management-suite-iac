output "acm_endpoint" {
  description = "URL for NMS API Connectivity Manager control host"
  value       = "https://${aws_instance.acm_example.public_ip}"
}

output "acm_host_ip" {
  description = "IP for NMS API Connectivity Manager control host"
  value       = aws_instance.acm_example.public_ip
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${aws_instance.acm_example.public_ip}"
}
