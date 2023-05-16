# AWS NGINX Devportal Image Generation

This directory contains templates and scripts to create an API Connectivity Manager Ubuntu image to be deployable to AWS

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You will need programmatic access to your AWS environment

## Getting Started

- For AWS AMI builds, you will need to set:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SECURITY_TOKEN
```

- Set packer build parameters in an optional `pkrvars.hcl` file

```bash
cp devportal.pkrvars.hcl.example devportal.pkrvars.hcl
```

- Run packer build

```shell
   packer build -var-file="devportal.pkrvars.hcl" ubuntu-aws-devportal.pkr.hcl
```

## Configuration

| Parameter               | Description                                                                                 | Default                                                               | Required |
| ----------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | -------- |
| ami_name                | _The name of the final AMI image_                                                           | `nginx-devportal-ubuntu-20-04-<nms_api_connectivity_manager_version>` | No       |
| base_ami_name           | _The name of the base AMI image_                                                            | -                                                                     | Yes      |
| base_ami_owner_acct     | _The owner of the base AMI image_                                                           | -                                                                     | Yes      |
| build_instance_type     | _The instance type to use for building the image_                                           | `t3.micro`                                                            | No       |
| build_region            | _The region to build the image in_                                                          | `us-west-1`                                                           | No       |
| destination_regions     | _The region or regions the image will be available in_                                      | `us-west-1`                                                           | No       |
| nginx_devportal_version | _The version to use for installing NGINX Devportal_                                         | `1.4.1`                                                               | No       |
| nginx_repo_cert         | _Path to cert required to access the yum/deb repo for NMS_                                  | -                                                                     | Yes      |
| nginx_repo_key          | _Path to key required to access the yum/deb repo for NMS_                                   | -                                                                     | Yes      |
| subnet_id               | _ID of subnet for the image to be built in, will attempt to use the default VPC if not set_ | -                                                                     | No       |
| embedded_pg             | _Specify if you would like to embed a postgres or sqlite onto the image_                    | `false`                                                               | No       |
