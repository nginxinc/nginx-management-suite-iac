/**
 * Copyright (c) F5, Inc.
 *
 * This source code is licensed under the Apache License, Version 2.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

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
