/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

output "devportal_host_ip" {
  description = "IP for NMS control host"
  value       = google_compute_instance.devportal_example.network_interface[0].access_config[0].nat_ip
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${google_compute_instance.devportal_example.network_interface[0].access_config[0].nat_ip}"
}
