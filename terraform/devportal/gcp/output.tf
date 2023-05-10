output "devportal_host_ip" {
  description = "IP for NMS API Connectivity Manager control host"
  value       = google_compute_instance.devportal_example.network_interface[0].access_config[0].nat_ip
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${google_compute_instance.devportal_example.network_interface[0].access_config[0].nat_ip}"
}
