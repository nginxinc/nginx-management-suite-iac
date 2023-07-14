# AWS NGINX Management Suite Basic Reference Architecture

This directory contains templates and scripts to deploy an NGINX Management Suite Ubuntu image to AWS

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You will need programmatic access to your AWS environment

## Getting Started

- For deploying to AWS with terraform, you will need to setup your AWS credentials:

```shell
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SECURITY_TOKEN
```

- Set terraform parameters in an optional `.tfvars` file

```shell
cp terraform.tfvars.example terraform.tfvars
```

- Use an environment variable to store the admin password you would like to use.

```
export TF_VAR_admin_password=xxxxxxxxxxxxxxx
```

- Initialise Terraform

  ```shell
      terraform init
  ```

- Apply Terraform

  ```shell
     terraform apply
  ```

## Configuration

| Parameter                 | Description                                                                                                                                                                                                                                            | Default             | Required |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- | -------- |
| admin_password            | _The password for the created `admin_user`_                                                                                                                                                                                                            | -                   | Yes      |
| admin_user                | _Name of the admin user_                                                                                                                                                                                                                               | `admin`             | No       |
| nms_ami_id                | _AMI Id of the NGINX Management Suite image to use_                                                                                                                                                                                                    | -                   | Yes      |
| agent_ami_id              | _AMI Id of the NGINX Agent image to use_                                                                                                                                                                                                               | -                   | Yes      |
| agent_instance_group_name | _Agent Instance group name_                                                                                                                                                                                                                            | -                   | Yes      |
| agent_count               | _The number of agents to deploy_                                                                                                                                                                                                                       | -                   | No       |
| nms_instance_type         | _AWS Instance type for NGINX Management Suite_                                                                                                                                                                                                         | `t3.medium`         | No       |
| agent_instance_type       | _AWS Instance type for the Agent Instance_                                                                                                                                                                                                             | `t3.micro`          | No       |
| aws_region                | _Region to deploy instance_                                                                                                                                                                                                                            | `us-west-1`         | No       |
| license_file_path         | _The path to the NGINX API Connectivity Manger license file_                                                                                                                                                                                           | -                   | Yes      |
| ssh_user                  | _User account name allowed access via ssh._                                                                                                                                                                                                            | `ubuntu`            | No       |
| ssh_pub_key               | _Path to the ssh pub key that will be used for sshing into the host_                                                                                                                                                                                   | `~/.ssh/id_rsa.pub` | No       |
| ssh_private_key           | _Path to the ssh private key that will be used for sshing into the host. NOTE: This file's permissions must not be set too open, or ssh will not connect ([see this post](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open))._ | `~/.ssh/id_rsa`     | No       |
| incoming_cidr_blocks      | _List of custom CIDR blocks to allow access to NGINX Management Suite UI. The Terraform source IP Is added by default._                                                                                                                                | -                   | No       |
