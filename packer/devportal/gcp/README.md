# GCP NGINX Devportal Image Generation

This directory contains templates and scripts to create an API Connectivity Manager Ubuntu image to be deployable to GCP

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to a GCP.

## Getting Started

- For GCP compute image builds, you will need to login:

Download and install the cli using these instructions: https://cloud.google.com/sdk/docs/install before signing in:

```shell
gcloud auth application-default login
```

- Set packer build parameters in an optional `pkrvars.hcl` file

```shell
cp devportal.pkrvars.hcl.example devportal.pkrvars.hcl
```

- Run packer build

```shell
   packer build -var-file="devportal.pkrvars.hcl" ubuntu-gcp-devportal.pkr.hcl
```

## Configuration

| Parameter               | Description                                                              | Default                                                               | Required |
| ----------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------- | -------- |
| build_instance_type     | _The instance type to use for building the image_                        | `e2.micro`                                                            | No       |
| build_zone              | _The GCP zone to build the image in_                                     | `europe-west4-a`                                                      | No       |
| embedded_pg             | _Specify if you would like to embed a postgres or sqlite onto the image_ | `false`                                                               | No       |
| image_name              | _The name of the final GCP image_                                        | `nginx-devportal-ubuntu-20-04-<nms_api_connectivity_manager_version>` | No       |
| nginx_devportal_version | _The version to use for installing NGINX Devportal_                      | `1.4.1`                                                               | No       |
| nginx_repo_cert         | _Path to cert required to access the yum/deb repo for NMS_               | -                                                                     | Yes      |
| nginx_repo_key          | _Path to key required to access the yum/deb repo for NMS_                | -                                                                     | Yes      |
| project_id              | _GCP project id to use_                                                  | -                                                                     | Yes      |
