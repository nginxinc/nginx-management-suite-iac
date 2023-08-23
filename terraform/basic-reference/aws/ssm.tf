resource "aws_iam_role" "nms_ec2_assume_role" {
  name = "nms_ec2_assume_role"

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
  name = "nms_ssm"
  role = aws_iam_role.nms_ec2_assume_role.name
  tags = var.tags
}

resource "aws_ssm_document" "restart_adm" {
  name          = "restart-adm"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Restart Application Delivery Manager to work",
    "mainSteps": [
      {
         "action": "aws:runShellScript",
         "name": "restart_adm",
         "inputs": {
            "timeoutSeconds": "60",
            "runCommand": [
               "systemctl restart nms-adm"
            ]
         }
      }
    ]
  }
DOC
}


resource "aws_ssm_association" "restart_adm" {
  name = aws_ssm_document.restart_adm.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.nms_example.id]
  }
}