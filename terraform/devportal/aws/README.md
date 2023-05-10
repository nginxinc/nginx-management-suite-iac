# AWS NGINX Devportal Image Deployment with embedded db.

This directory contains templates and scripts to deploy an NGINX Devportal Ubuntu image to AWS

1. Follow the generic README, situated [here](../../README.md)

2. For deploying to AWS with terraform, you will need to setup your AWS credentials:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SECURITY_TOKEN
```

3. Set terraform parameters in an optional `.tfvars` file

```bash
cp terraform.tfvars.example terraform.tfvars
```

4. Initialise Terraform

   ```
       terraform init
   ```

5. Apply Terraform
   ```
      terraform apply
   ```

## Configuration

| Parameter            | Description                                                                                                                          | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------- | -------- |
| ami_id               | _AMI Id of image to use_                                                                                                             | -                   | Yes      |
| aws_region           | _Region to deploy instance_                                                                                                          | `us-west-1`         | No       |
| db_host              | _Host of the db to connect to._                                                                                                      | `localhost`         | No       |
| db_password          | _Database password._                                                                                                                 | `complexPassword1*` | No       |
| db_type              | _Type of database. Either psql or sqlite._                                                                                           | `psql`              | No       |
| db_user              | _Database user._                                                                                                                     | `nginx-devportal`   | No       |
| db_ca_cert_file      | _Database CA File (If using a custom CA file)._                                                                                      | -                   | No       |
| db_client_cert_file  | _DB Client Cert File (Required for mTLS with DB)._                                                                                   | -                   | No       |
| db_client_key_file   | _DB Client Key File (Required for mTLS with DB)._                                                                                    | -                   | No       |
| incoming_cidr_blocks | _List of cidr blocks (used to allow inbound access in public cloud). If unset will allow public IP of machine using terraform_       | -                   | No       |
| instance_type        | _The size of the AWS Instance. When deploying with an embedded database the minimum instance size is medium with a t3 architecture._ | `t3.medium`         | No       |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                                                 | `~/.ssh/id_rsa.pub` | No       |
| ssh_private_key      | _Path to the private key that will be used for sshing into the host_                                                                 | `~/.ssh/id_rsa`     | No       |
| ssh_user             | _The user used for sshing into the host_                                                                                             | `ubuntu`            | No       |
| subnet_id            | _ID of subnet to use for this instance. If unset, then a new vpc & subnet will be created._                                          | -                   | No       |
