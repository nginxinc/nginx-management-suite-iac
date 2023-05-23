# GCP API Connectivity Manager Image Generation

This directory contains templates and scripts to create an API Connectivity Manager Ubuntu image to be deployable to GCP

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to a GCP.

## Getting Started

- For GCP compute image builds, you will need to login:

```shell
gcloud auth application-default login
```

- Set packer build parameters in an optional `pkrvars.hcl` file

```shell
cp acm.pkrvars.hcl.example acm.pkrvars.hcl
```

- Run packer build

```shell
   packer build -var-file="acm.pkrvars.hcl" ubuntu-gcp-acm.pkr.hcl
```

## Configuration

| Parameter                            | Description                                                      | Default                                                   | Required |
| ------------------------------------ | ---------------------------------------------------------------- | --------------------------------------------------------- | -------- |
| base_image_name                      | _The name of the base AMI image_                                 | `ubuntu-2204-jammy-v20230114`                             | No       |
| build_zone                           | _The GCP zone to build the image in_                             | `europe-west4-a`                                          | No       |
| build_instance_type                  | _The instance type to use for building the image_                | `e2-micro`                                                | No       |
| image_name                           | _The name of the final GCP image_                                | `acm-ubuntu-22-04-<nms_api_connectivity_manager_version>` | No       |
| nms_api_connectivity_manager_version | _The version to use for installing NMS Api Connectivity Manager_ | `1.6.0`                                                   | No       |
| nginx_repo_cert                      | _Path to cert required to access the yum/deb repo for NMS_       | -                                                         | Yes      |
| nginx_repo_key                       | _Path to key required to access the yum/deb repo for NMS_        | -                                                         | Yes      |
| project_id                           | _GCP project id to use_                                          | -                                                         | Yes      |
