# AWS NGINX Image Generation

This directory contains templates and scripts to create a Ubuntu NGINX image to be deployable to AWS.
The image is just a fresh install of NGINX with an njs module installed. The agent should be installed from the controller instance after it is deployed.

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You will need programmatic access to your AWS environment

## Getting Started

- For AWS AMI builds, you will need to set:

```shell
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SECURITY_TOKEN
```

- Set packer build parameters in a `pkrvars.hcl` file

```shell
cp nginx.pkrvars.hcl.example nginx.pkrvars.hcl
```

- Customise your packer hcl files to suit your environment.
- Install ansible plugin for [AWS](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon) & [Ansible](https://developer.hashicorp.com/packer/integrations/hashicorp/ansible)

```shell
   packer plugins install github.com/hashicorp/amazon
   packer plugins install github.com/hashicorp/ansible
```

- Run packer build

```shell
   packer build -var-file="nginx.pkrvars.hcl" nginx.pkr.hcl
```

## Configuration

| Parameter           | Description                                                                                 | Default               | Required |
| ------------------- | ------------------------------------------------------------------------------------------- | --------------------- | -------- |
| ami_name            | _The name of the final AMI image_                                                           | `nginx-<YYYY-MM-DD>`  | No       |
| base_ami_name       | _The name of the base AMI image_                                                            | -                     | Yes      |
| base_ami_owner_acct | _The owner of the base AMI image_                                                           | -                     | Yes      |
| build_instance_type | _The instance type to use for building the image_                                           | `t3.micro`            | No       |
| build_region        | _The region to build the image in_                                                          | `us-west-1`           | No       |
| destination_regions | _The region or regions the image will be available in_                                      | `us-west-1`           | No       |
| nginx_repo_cert     | _Path to cert required to access the yum/deb repo for NMS_                                  | -                     | Yes      |
| nginx_repo_key      | _Path to key required to access the yum/deb repo for NMS_                                   | -                     | Yes      |
| subnet_id           | _ID of subnet for the image to be built in, will attempt to use the default VPC if not set_ | -                     | No       |
| tags                | _Map of tags to apply to resulting AWS AMI image_                                           | `{}`                  | No       |
