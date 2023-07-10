# Azure NGINX Devportal Deployment

This directory contains templates and scripts to deploy an NGINX Devportal Ubuntu image to Azure

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You will need to authenticate to Azure to deploy this infrastructure. For this example we will create and use a service principal. Feel free to change this to suit your needs:

## Creating a service principal

[Terraform Azure Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[Terraform Azure Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

```shell
az ad sp create-for-rbac --name terraform --role contributor --scopes /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/my-resource-group-name --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

## Getting Started

- Add the following environment variables from the output of the service principal.

```shell
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
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

- Navigate to the url in the terraform. Go to the settings. Upload your API-Connectivity-Manager license.

## Configuration

| Parameter            | Description                                                                                                   | Default             | Required |
| -------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------- | -------- |
| image_name           | _Image being deployed_                                                                                        | -                   | Yes      |
| resource_group_name  | _The Azure resource group ID to use._                                                                         | -                   | Yes      |
| db_host              | _Host of the db to connect to._                                                                               | `localhost`         | No       |
| db_password          | _Database password._                                                                                          | `complexPassword1*` | No       |
| db_type              | _Type of database. Either psql or sqlite._                                                                    | `psql`              | No       |
| db_user              | _Database user._                                                                                              | `nginx-devportal`   | No       |
| db_ca_cert_file      | _Database CA File (If using a custom CA file)._                                                               | -                   | No       |
| db_client_cert_file  | _DB Client Cert File (Required for mTLS with DB)._                                                            | -                   | No       |
| db_client_key_file   | _DB Client Key File (Required for mTLS with DB)._                                                             | -                   | No       |
| incoming_cidr_blocks | _List of custom CIDR blocks to allow access to NGINX Devportal. The Terraform source IP Is added by default._ | -                   | No       |
| instance_type        | _Azure compute instance type to use._                                                                         | `Standard_B2s`      | No       |
| ssh_pub_key          | _Path to the ssh pub key that will be used for sshing into the host_                                          | `~/.ssh/id_rsa.pub` | No       |
| ssh_user             | _User account name allowed access via ssh._                                                                   | `ubuntu`            | No       |
