# GCP API Connectivity Manager Image Deployment

This directory contains templates and scripts to deploy an API Connectivity Manager Ubuntu image to GCP

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to a GCP cloud.

## Getting Started

- For deploying to GCP with terraform, you will need to login to gcloud:

```bash
gcloud auth application-default login
```

- Set terraform parameters in an optional `.tfvars` file

```bash
cp terraform.tfvars.example terraform.tfvars
```

- Initialise Terraform

  ```
      terraform init
  ```

- Populate the .tfvars file with vars relative to your environment.

- Apply Terraform
  ```
     terraform apply
  ```

## Configuration

| Parameter            | Description                                                                                                               | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------- | -------- |
| admin_passwd         | _The password for the created `admin_user`_                                                                               | -                   | Yes      |
| admin_user           | _Name of the admin user_                                                                                                  | `admin`             | No       |
| image_name           | _Image being deployed_                                                                                                    | -                   | Yes      |
| incoming_cidr_blocks | _List of custom CIDR blocks to allow access to API Connectivity Manager UI. The Terraform source IP Is added by default._ | -                   | No       |
| instance_type        | _GCP compute instance type to use._                                                                                       | `e2-micro`          | No       |
| project_id           | _The GCP project ID to use._                                                                                              | -                   | Yes      |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                                      | `~/.ssh/id_rsa.pub` | No       |
| ssh_user             | _User account name allowed access via ssh._                                                                               | `ubuntu`            | No       |
