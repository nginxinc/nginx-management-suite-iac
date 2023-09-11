# AWS NGINX Management Suite Image Deployment

This directory contains templates and scripts to deploy an NGINX Management Suite Ubuntu image to AWS

## Requirements

- You have followed the generic README, situated [here](../../../README.md)
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

- Populate the .tfvars file with vars relative to your environment.

- Use an environment variable to store the admin password you would like to use.

```
export TF_VAR_admin_password=xxxxxxxxxxxxxxx
```

- Add the required IP ranges to the "incoming_cidr_blocks" in order to access the NMS service.

- Initialise Terraform

  ```shell
      terraform init
  ```

- Apply Terraform

  ```shell
     terraform apply
  ```

## Configuration

| Parameter            | Description                                                                                 | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------- | ------------------- | -------- |
| admin_password       | _The password for the created `admin_user`_                                                 | -                   | Yes      |
| ami_id               | _AMI Id of image to use_                                                                    | -                   | Yes      |
| instance_type        | _AWS Instance type for API Connectivity Manager_                                            | `t2.medium`         | No       |
| aws_region           | _Region to deploy instance_                                                                 | `us-west-1`         | No       |
| ssh_user             | _User account name allowed access via ssh._                                                 | `ubuntu`            | No       |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                        | `~/.ssh/id_rsa.pub` | No       |
| subnet_id            | _ID of subnet to use for this instance. If unset, then a new vpc & subnet will be created._ | -                   | No       |
| incoming_cidr_blocks | _List of custom CIDR blocks to allow access to NGINX Management Suite UI._                  | -                   | No       |
| disk_config          | _Map of size and device paths for attached storage_                                         | See example file    | Yes      |
| tags                 | _Map of tags to apply to resulting AWS resources_                                           | `{}`                | No       |

Note: [See AWS documentation regarding aws_instance types and block device names for ebs attached storage](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html)
