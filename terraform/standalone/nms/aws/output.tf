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
  value       = aws_instance.nms_example.public_ip
}

output ssh_command {
  value = "ssh ${var.ssh_user}@${aws_instance.nms_example.public_ip}"
}
