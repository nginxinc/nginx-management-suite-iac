# GCP NGINX Devportal Image Deployment

This directory contains templates and scripts to deploy an NGINX Devportal Ubuntu image to GCP

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to a GCP cloud.

## Getting Started

- For deploying to GCP with terraform, you will need to login to gcloud:

Download and install the cli using these instructions: https://cloud.google.com/sdk/docs/install before signing in:

```shell
gcloud auth application-default login
```

- Set terraform parameters in an optional `.tfvars` file

```shell
cp terraform.tfvars.example terraform.tfvars
```

- Initialise Terraform

  ```shell
      terraform init
  ```

- Populate the .tfvars file with vars relative to your environment.

- Apply Terraform

  ```shell
     terraform apply
  ```

## Configuration

| Parameter            | Description                                                                                                                          | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------- | -------- |
| project_id           | _The GCP project ID to use._                                                                                                         | -                   | Yes      |
| db_ca_cert_file      | _Database CA File (If using a custom CA file)._                                                                                      | -                   | No       |
| db_client_cert_file  | _DB Client Cert File (Required for mTLS with DB)._                                                                                   | -                   | No       |
| db_client_key_file   | _DB Client Key File (Required for mTLS with DB)._                                                                                    | -                   | No       |
| db_host              | _Host of the db to connect to._                                                                                                      | `localhost`         | No       |
| db_password          | _Database password._                                                                                                                 | `complexPassword1*` | No       |
| db_type              | _Type of database. Either psql or sqlite._                                                                                           | `psql`              | No       |
| db_user              | _Database user._                                                                                                                     | `nginx-devportal`   | No       |
| image_name           | _Image being deployed._                                                                                                              | -                   | Yes      |
| incoming_cidr_blocks | _List of cidr blocks (used to allow inbound access in public cloud). If unset will allow public IP of machine using terraform_       | -                   | No       |
| instance_type        | _The size of the AWS Instance. When deploying with an embedded database the minimum instance size is medium with a t3 architecture._ | `e2.micro`          | No       |
| region               | _Region to deploy instance_                                                                                                          | `europe-west4`      | No       |
| ssh_private_key      | _Path to the ssh private key that will be used for sshing into the host_                                                             | `~/.ssh/id_rsa`     | No       |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                                                 | `~/.ssh/id_rsa.pub` | No       |
| ssh_user             | _The user used for sshing into the host_                                                                                             | -                   | No       |
