# vSphere API Connectivity Manager Machine Template Deployment

This directory contains templates and scripts to deploy an API Connectivity Manager Ubuntu Virtual Machine to vSphere.

## Requirements

- You have followed the generic README, situated [here](../../../README.md)
- Access to vSphere environment variables.

## Getting Started

- For deploying to vSphere with terraform, you will need to set your vSphere environment credentials:

```shell
export TF_VAR_vsphere_url="my-vcenter-url.com"
export TF_VAR_vsphere_password="my-password"
export TF_VAR_vsphere_user="my-username"
```

- Set terraform parameters in an optional `.tfvars` file

```shell
cp terraform.tfvars.example terraform.tfvars
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

| Parameter        | Description                                                          | Default             | Required |
| ---------------- | -------------------------------------------------------------------- | ------------------- | -------- |
| admin_passwd     | _The password for the created `admin_user`_                          | -                   | Yes      |
| admin_user       | _Name of the admin user_                                             | `admin`             | No       |
| cluster_name     | _The vSphere cluster name_                                           | -                   | Yes      |
| datacenter       | _The vSphere datacenter name_                                        | -                   | Yes      |
| datastore        | _The vSphere datastore name_                                         | -                   | Yes      |
| network          | _The name of the vSphere network to place the template in_           | -                   | Yes      |
| ssh_pub_key      | _Path to the ssh pub key that will be used for sshing into the host_ | `~/.ssh/id_rsa.pub` | No       |
| ssh_user         | _User account name allowed access via ssh._                          | `ubuntu`            | No       |
| template_name    | _Template being deployed_                                            | -                   | Yes      |
| vsphere_password | _The password of the executing vSphere user. _                       | Environment value   | No       |
| vsphere_url      | _The url of the vSphere API. _                                       | Environment value   | No       |
| vsphere_username | _The name of the executing vSphere user._                            | Environment value   | No       |
