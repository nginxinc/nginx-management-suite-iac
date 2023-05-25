# Azure NGINX Devportal Image Generation

This directory contains templates and scripts to create an NGINX Devportal Ubuntu image to be deployable to Azure

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You have access to a service principal or the permissions to create one.

## Creating a service principal

- For Azure builds, you will need to install the Azure CLI :

```shell
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

- You will need to authenticate to build and save images on Azure. For this example we will create and use a service principal. Feel free to change this to suit your needs:

[Terraform Azure Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[Terraform Azure Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

## Getting Started

```shell
az ad sp create-for-rbac --name packer --role contributor --scopes /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/my-resource-group-name --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

- Add the following environment variables from the output of the service principal.

```shell
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

- Set packer build parameters in a `pkrvars.hcl` file

```shell
cp devportal.pkrvars.hcl.example devportal.pkrvars.hcl
```

- Run packer build

```shell
   packer build -var-file="devportal.pkrvars.hcl" ubuntu-azure-devportal.pkr.hcl
```

## Configuration

| Parameter               | Description                                                              | Default                                                  | Required |
| ----------------------- | ------------------------------------------------------------------------ | -------------------------------------------------------- | -------- |
| base_image_offer        | _The name of the base compute image_                                     | -                                                        | Yes      |
| base_image_publisher    | _The owner of the base compute image_                                    | -                                                        | Yes      |
| base_image_sku          | _The sku of the base compute image_                                      | -                                                        | Yes      |
| build_instance_type     | _The instance type to use for building the image_                        | `Standard_B1s`                                           | No       |
| embedded_pg             | _Specify if you would like to embed a postgres or sqlite onto the image_ | `false`                                                  | No       |
| image_name              | _The name of the final GCP image_                                        | `nginx-devportal-ubuntu-20-04-<nginx_devportal_version>` | No       |
| nginx_devportal_version | _The version to use for installing NGINX Devportal_                      | `1.6.0`                                                  | No       |
| nginx_repo_cert         | _Path to cert required to access the yum/deb repo for NMS_               | -                                                        | Yes      |
| nginx_repo_key          | _Path to key required to access the yum/deb repo for NMS_                | -                                                        | Yes      |
| resource_group_name     | _The resource group where the build and final image is located_          | -                                                        | Yes      |
