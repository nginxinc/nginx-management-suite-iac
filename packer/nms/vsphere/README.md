# NGINX Management Suite Control Host Template Generation for vSphere

This directory contains templates and scripts to create an NGINX Management Suite Ubuntu template to be deployable to VSphere

## Requirements

- You have followed the generic README, situated [here](../../README.md)
- Access to VSphere environment variables.

## Getting Started

- For VSphere Template builds, you will need to set the following environment variables:

```shell
export VSPHERE_URL="my-vcenter-url.com"
export VSPHERE_PASSWORD="my-password"
export VSPHERE_USER="my-username"
```

If you would like the overwrite the console password for the ubuntu user in the VM Template, set the following environment variable.

```shell
export CONSOLE_PASSWORD="my-password"
```

- Install packer compatible ISO tools on the executing machine

```shell
sudo apt-get install mkisofs
```

- Set packer build parameters in a `pkrvars.hcl` file

```shell
cp nms.pkrvars.hcl.example nms.pkrvars.hcl
```

- Run packer build

```shell
   ./packer-build.sh -var-file="nms.pkrvars.hcl"
```

You may pass as many packer command line variables as you would like to the shell script.
To overwrite a saved template use the `-force` flag.

## Configuration

| Parameter                        | Description                                                                 | Default                                             | Required |
| -------------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------- | -------- |
| boot_command                     | _Boot command to run on machine_                                            |                                                     | No       |
| cluster_name                     | _The vSphere cluster name_                                                  | -                                                   | Yes      |
| datacenter                       | _The vSphere datacenter name_                                               | -                                                   | Yes      |
| datastore                        | _The vSphere datastore name_                                                | -                                                   | Yes      |
| template_name                    | _The name of the final vSphere template_                                    | `nms-ubuntu-22-04-<nginx_management_suite_version>` | No       |
| iso_path                         | _Path to the desired ISO to use eg. ISO/ubuntu-22.04-live-server-amd64.iso_ | -                                                   | Yes      |
| network                          | _The name of the vSphere network to place the template in_                  | -                                                   | Yes      |
| nginx_management_suite_version   | _The version to use for installing NMS NGINX Management Suite_              | `1.7.0`                                             | No       |
| nms_app_delivery_manager_version | _The version to use for installing NMS App Delivery Manager_                | `4.0.0`                                             | No       |
| nms_security_monitoring_version  | _The version to use for installing NMS Security Module_                     | `1.5.0`                                             | No       |
| nginx_repo_cert                  | _Path to cert required to access the yum/deb repo for NMS_                  | -                                                   | Yes      |
| nginx_repo_key                   | _Path to key required to access the yum/deb repo for NMS_                   | -                                                   | Yes      |
| vsphere_password                 | _The password of the executing vSphere user. _                              | Environment value                                   | No       |
| vsphere_url                      | _The url of the vSphere API. _                                              | Environment value                                   | No       |
| vsphere_username                 | _The name of the executing vSphere user._                                   | Environment value                                   | No       |
