output "devportal_host_ip" {
  description = "IP for NMS API Connectivity Manager control host"
  value       = aws_instance.devportal_example.public_ip
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${aws_instance.devportal_example.public_ip}"
}
