/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
*/

output nms_host_ip {
  value       = google_compute_instance.nms_example.network_interface[0].access_config[0].nat_ip
  description = "IP for NMS control host"
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${google_compute_instance.nms_example.network_interface[0].access_config[0].nat_ip}"
}

output "nms_endpoint" {
  description = "URL for NMS control host"
  value       = "https://${google_compute_instance.nms_example.network_interface[0].access_config[0].nat_ip }"
}
