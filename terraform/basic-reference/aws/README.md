# AWS API Connectivity Manager Basic Reference Architecture

This directory contains templates and scripts to deploy an API Connectivity Manager Ubuntu image to AWS

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

| Parameter            | Description                                                                                                               | Default                 | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------- | -------- |
| admin_passwd         | _The password for the created `admin_user`_                                                                               | -                       | Yes      |
| admin_user           | _Name of the admin user_                                                                                                  | `admin`                 | No       |
| acm_ami_id           | _AMI Id of the API Connectivity Manager image to use_                                                                     | -                       | Yes      |
| agent_ami_id         | _AMI Id of the NGINX Agent image to use_                                                                                  | -                       | Yes      |
| agent_count          | _The number of agents to deploy_                                                                                          | -                       | No       |
| acm_instance_type    | _AWS Instance type for API Connectivity Manager_                                                                          | `t3.medium`             | No       |
| agent_instance_type  | _AWS Instance type for the Agent Instance_                                                                                | `t3.micro`              | No       |
| aws_region           | _Region to deploy instance_                                                                                               | `us-west-1`             | No       |
| devportal_zone       | _Zone to use for the devportal_                                                                                           | `devportal.example.com` | No       |
| license_file_path    | _The path to the NGINX API Connectivity Manger license file_                                                              | -                       | Yes      |
| ssh_user             | _User account name allowed access via ssh._                                                                               | `ubuntu`                | No       |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                                      | `~/.ssh/id_rsa.pub`     | No       |
| incoming_cidr_blocks | _List of custom CIDR blocks to allow access to API Connectivity Manager UI. The Terraform source IP Is added by default._ | -                       | No       |
