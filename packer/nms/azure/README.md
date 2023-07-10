# NGINX Management Suite Control Host Image Generation for Azure

This directory contains templates and scripts to create an NGINX Management Suite Ubuntu image to be deployable to Azure

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- You have access to a service principal or the permissions to create one.
- For Azure builds, you will need to install the Azure CLI :

```shell
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Creating a service principal

- You will need to authenticate to build and save images on Azure. For this example we will create and use a service principal. Feel free to change this to suit your needs:

[Packer Azure Docs](https://developer.hashicorp.com/packer/plugins/builders/azure/arm)
[Packer Azure Service Principal](https://developer.hashicorp.com/packer/plugins/builders/azure#azure-active-directory-service-principal)

```shell
az ad sp create-for-rbac --name packer --role contributor --scopes /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/my-resource-group-name --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

## Getting Started

- Add the following environment variables from the output of the service principal.

```shell
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

- Set packer build parameters in a `pkrvars.hcl` file

```shell
cp nms.pkrvars.hcl.example nms.pkrvars.hcl
```

- Customise your packer hcl files to suit your environment.

- Run packer build

```shell
   packer build -var-file="nms.pkrvars.hcl" ubuntu-azure-nms.pkr.hcl
```

## Configuration

| Parameter                        | Description                                                      | Default                                             | Required |
| -------------------------------- | ---------------------------------------------------------------- | --------------------------------------------------- | -------- |
| base_image_offer                 | _The name of the base compute image_                             | -                                                   | Yes      |
| base_image_publisher             | _The owner of the base compute image_                            | -                                                   | Yes      |
| base_image_sku                   | _The sku of the base compute image_                              | -                                                   | Yes      |
| build_instance_type              | _The instance type to use for building the image_                | `Standard_B1s`                                      | No       |
| image_name                       | _The name of the final compute image_                            | `nms-ubuntu-20-04-<nginx_management_suite_version>` | No       |
| nginx_management_suite_version   | _The version to use for installing NMS Api Connectivity Manager_ | `1.7.0`                                             | No       |
| nms_app_delivery_manager_version | _The version to use for installing NMS App Delivery Manager_     | `4.0.0`                                             | No       |
| nms_security_monitoring_version  | _The version to use for installing NMS Security Module_          | `1.5.0`                                             | No       |
| nginx_repo_cert                  | _Path to cert required to access the yum/deb repo for NMS_       | -                                                   | Yes      |
| nginx_repo_key                   | _Path to key required to access the yum/deb repo for NMS_        | -                                                   | Yes      |
| resource_group_name              | _The resource group where the build and final image is located_  | -                                                   | Yes      |
