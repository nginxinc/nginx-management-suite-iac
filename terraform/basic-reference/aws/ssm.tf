resource "aws_iam_role" "nms_ec2_assume_role" {
  name = "${var.prefix}-nms_ec2_assume_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "nms_ssm" {
  role       = aws_iam_role.nms_ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nms_ssm" {
  name = "${var.prefix}-nms_ssm"
  role = aws_iam_role.nms_ec2_assume_role.name
  tags = var.tags
}
