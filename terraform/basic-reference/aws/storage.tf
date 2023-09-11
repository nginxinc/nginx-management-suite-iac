resource "aws_ebs_volume" "disks" {
  count             = length(local.disks)
  availability_zone = random_shuffle.random_az.result[0]
  size              = local.disks[count.index].size
  tags              = var.tags
}

resource "aws_volume_attachment" "disks" {
  count                          = length(local.disks)
  device_name                    = local.disks[count.index].device
  volume_id                      = aws_ebs_volume.disks[count.index].id
  instance_id                    = aws_instance.nms_example.id
  stop_instance_before_detaching = true
}
