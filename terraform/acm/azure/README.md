# Azure API Connectivity Manager Image Deployment

This directory contains templates and scripts to deploy an API Connectivity Manager Ubuntu image to Azure

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You have access to a service principal or the permissions to create one.

## Creating a service principal.

[Terraform Azure Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[Terraform Azure Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

```bash
az ad sp create-for-rbac --name terraform --role contributor --scopes /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/my-resource-group-name --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

## Getting Started

- Add the following environment variables from the output of the service principal.

```
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

- Set terraform parameters in an optional `.tfvars` file

```bash
cp terraform.tfvars.example terraform.tfvars
```

- Populate the .tfvars file with vars relative to your environment.

- Initialise Terraform

  ```
      terraform init
  ```

- Populate the .tfvars file with vars relative to your environment.

- Apply Terraform

  ```
     terraform apply
  ```

- Navigate to the url in the terraform. Go to the settings. Upload your API-Connectivity-Manager license.

## Configuration

| Parameter            | Description                                                                                                               | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------- | -------- |
| admin_passwd         | _The password for the created `admin_user`_                                                                               | -                   | Yes      |
| admin_user           | _Name of the admin user_                                                                                                  | `admin`             | No       |
| image_name           | _Image being deployed_                                                                                                    | -                   | Yes      |
| incoming_cidr_blocks | _List of custom CIDR blocks to allow access to API Connectivity Manager UI. The Terraform source IP Is added by default._ | -                   | No       |
| instance_type        | _Azure compute instance type to use._                                                                                     | `Standard_B2s`      | No       |
| resource_group_name  | _The Azure resource group ID to use._                                                                                     | -                   | Yes      |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                                      | `~/.ssh/id_rsa.pub` | No       |
| ssh_user             | _User account name allowed access via ssh._                                                                               | `ubuntu`            | No       |
