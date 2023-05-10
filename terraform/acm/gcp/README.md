GCP API Connectivity Manager Image Deployment
===============

This directory contains templates and scripts to deploy an API Connectivity Manager Ubuntu image to GCP

1. Follow the generic README, situated [here](../../README.md)

2. For deploying to GCP with terraform, you will need to login to gcloud:
```bash
gcloud auth application-default login
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

|Parameter|Description|Default|Required|
|---|---|---|---|
|admin_passwd|*The password for the created `admin_user`*|-|Yes|
|admin_user|*Name of the admin user*|`admin`|No|
|image_name|*Image being deployed*|-|Yes|
|incoming_cidr_blocks|*List of custom CIDR blocks to allow access to API Connectivity Manager UI. The Terraform source IP Is added by default.*|-|No|
|instance_type|*GCP compute instance type to use.*|`e2-micro`|No|
|project_id|*The GCP project ID to use.*|-|Yes|
|ssh_pub_key|*Path to the ssh pub key that will be used for sshing into the host*|`~/.ssh/id_rsa.pub`|No|
|ssh_user|*User account name allowed access via ssh.*|`ubuntu`|No|
