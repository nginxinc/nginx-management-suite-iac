# NGINX Management Suite Control Host Image Generation for GCP

This directory contains templates and scripts to create an NGINX Management Suite Ubuntu image to be deployable to GCP

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to a GCP.

## Getting Started

- Download and install the cli using these instructions: https://cloud.google.com/sdk/docs/install:

- Authenticate with GCP:

```shell
gcloud auth application-default login
```

- Set packer build parameters in a `pkrvars.hcl` file

```shell
cp nms.pkrvars.hcl.example nms.pkrvars.hcl
```

- Run packer build

```shell
   packer build -var-file="nms.pkrvars.hcl" nms.pkr.hcl
```

## Configuration

| Parameter                            | Description                                              | Default                       | Required |
|--------------------------------------|----------------------------------------------------------| ----------------------------- | -------- |
| base_image_name                      | _The name of the base AMI image_                         | `ubuntu-2204-jammy-v20230114` | No       |
| build_zone                           | _The GCP zone to build the image in_                     | `europe-west4-a`              | No       |
| build_instance_type                  | _The instance type to use for building the image_        | `e2-micro`                    | No       |
| image_name                           | _The name of the final GCP image_                        | `nms-<YYYY-MM-DD>`            | No       |
| nms_api_connectivity_manager_version | _The version to use for installing NMS Api Connectivity Manager_ | `*`                           | No       |
| nms_security_monitoring_version      | _The version to use for installing NMS Security Module_  | `*`                           | No       |
| nginx_repo_cert                      | _Path to cert required to access the yum/deb repo for NMS_ | -                             | Yes      |
| nginx_repo_key                       | _Path to key required to access the yum/deb repo for NMS_ | -                             | Yes      |
| project_id                           | _GCP project id to use_                                  | -                             | Yes      |
| network_name                         | _GCP VPC network name with access to port 22/443_        | -                             | Yes      |
| labels                               | _Map of labels to apply to resulting GCP image_          | `{}`                          | No       |
