output acm_host_ip {
  value       = google_compute_instance.acm_example.network_interface[0].access_config[0].nat_ip
  description = "IP for NMS API Connectivity Manager control host"
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${google_compute_instance.acm_example.network_interface[0].access_config[0].nat_ip}"
}

output "acm_endpoint" {
  description = "URL for NMS API Connectivity Manager control host"
  value       = "https://${google_compute_instance.acm_example.network_interface[0].access_config[0].nat_ip }"
}
