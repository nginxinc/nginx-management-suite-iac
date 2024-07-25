# AWS NGINX Instance Manager Basic Reference Architecture

This directory contains templates and scripts to deploy an NGINX Instance Manager Ubuntu image to AWS

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

- Add the required IP ranges to the "mgmt_cidr_blocks" and "dataplane_cidr_blocks" in order to access the NMS and Dataplane services.

- Initialise Terraform

  ```shell
      terraform init
  ```

- Apply Terraform

  ```shell
     terraform apply
  ```

## Configuration

| Parameter                 | Description                                                                                  | Default             | Required |
|---------------------------|----------------------------------------------------------------------------------------------|---------------------|----------|
| admin_password            | _The password for the admin user_                                                            | -                   | Yes      |
| nms_ami_id                | _AMI Id of the NGINX Instance Manager image to use_                                          | -                   | Yes      |
| nginx_ami_id              | _AMI Id of the NGINX image to use_                                                           | -                   | Yes      |
| agent_instance_group_name | _Agent Instance group name_                                                                  | -                   | Yes      |
| agent_count               | _The number of agents to deploy_                                                             | -                   | No       |
| nms_instance_type         | _AWS Instance type for NGINX Instance Manager_                                               | `t2.medium`         | No       |
| nginx_instance_type       | _AWS Instance type for the NGINX instances Instance_                                         | `t3.micro`          | No       |
| aws_region                | _Region to deploy instance_                                                                  | `us-west-1`         | No       |
| license_file_path         | _The path to the NGINX API Connectivity Manger license file_                                 | -                   | Yes      |
| ssh_user                  | _User account name allowed access via ssh._                                                  | `ubuntu`            | No       |
| ssh_pub_key               | _Path to the ssh pub key that will be used for sshing into the host_                         | `~/.ssh/id_rsa.pub` | No       |
| mgmt_cidr_blocks          | _List of CIDR blocks to allow access to NGINX Instance Manager UI._                          | -                   | No       |
|                           | _Add the ip of the host you are running the terraform to access while applying the license._ |                     |          |
| dataplane_cidr_blocks     | _List of CIDR blocks to allow access to the dataplane instances._                            | -                   | No       |
| disk_config               | _Map of size and device paths for attached storage_                                          | See example file    | Yes      |
| tags                      | _Map of tags to apply to resulting AWS resources_                                            | `{}`                | No       |
| prefix                    | _Prefix to add in the name of the deployment_                                                | ""                  | Yes      |

Note: [See AWS documentation regarding aws_instance types and block device names for ebs attached storage](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html)
