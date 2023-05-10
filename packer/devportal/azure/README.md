# Azure NGINX Devportal Image Generation

This directory contains templates and scripts to create an NGINX Devportal Ubuntu image to be deployable to Azure

1. Follow the generic README, situated [here](../../README.md)

2. For Azure builds, you will need to install the Azure CLI :

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

3. You will need to authenticate to build and save images on Azure. For this example we will create and use a service principal. Feel free to change this to suit your needs:

[Terraform Azure Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
[Terraform Azure Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

```bash
az ad sp create-for-rbac --name packer --role contributor --scopes /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/my-resource-group-name --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

4. Add the following environment variables from the output of the service principal.

```
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

5. Set packer build parameters in an optional `pkrvars.hcl` file

```bash
cp devportal.pkrvars.hcl.example devportal.pkrvars.hcl
```

6. Run packer build

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
| nginx_devportal_version | _The version to use for installing NGINX Devportal_                      | `1.4.1`                                                  | No       |
| nginx_repo_cert         | _Path to cert required to access the yum/deb repo for NMS_               | -                                                        | Yes      |
| nginx_repo_key          | _Path to key required to access the yum/deb repo for NMS_                | -                                                        | Yes      |
| resource_group_name     | _The resource group where the build and final image is located_          | -                                                        | Yes      |
