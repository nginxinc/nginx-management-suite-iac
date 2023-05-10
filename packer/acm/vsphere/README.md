# VSphere API Connectivity Manager Template Generation

This directory contains templates and scripts to create an API Connectivity Manager Ubuntu template to be deployable to VSphere

1. Follow the generic README, situated [here](../../README.md)

2. For VSphere Template builds, you will need to set the following environment variables:

```
export VSPHERE_URL="my-vcenter-url.com"
export VSPHERE_PASSWORD="my-password"
export VSPHERE_USER="my-username"
```

If you would like the overwrite the console password for the ubuntu user in the VM Template, set the following environment variable.

```
export CONSOLE_PASSWORD="my-password"
```

3. Install packer compatable ISO tools on the executing machine

```
sudo apt-get install mkisofs
```

4. Set packer build parameters in an optional `pkrvars.hcl` file

```bash
cp acm.pkrvars.hcl.example acm.pkrvars.hcl
```

5. Run packer build

```shell
   ./packer-build.sh -var-file="acm.pkrvars.hcl"
```

You may pass as many packer command line variables as you would like to the shell script.
To overwrite a saved template use the `-force` flag.

## Configuration

| Parameter                            | Description                                                                 | Default                                                   | Required |
| ------------------------------------ | --------------------------------------------------------------------------- | --------------------------------------------------------- | -------- |
| boot_command                         | _Boot command to run on machine_                                            |                                                           | No       |
| cluster_name                         | _The vSphere cluster name_                                                  | -                                                         | Yes      |
| datacenter                           | _The vSphere datacenter name_                                               | -                                                         | Yes      |
| datastore                            | _The vSphere datastore name_                                                | -                                                         | Yes      |
| template_name                        | _The name of the final vSphere template_                                    | `acm-ubuntu-22-04-<nms_api_connectivity_manager_version>` | No       |
| iso_path                             | _Path to the desired ISO to use eg. ISO/ubuntu-22.04-live-server-amd64.iso_ | -                                                         | Yes      |
| network                              | _The name of the vSphere network to place the template in_                  | -                                                         | Yes      |
| nms_api_connectivity_manager_version | _The version to use for installing NMS Api Connectivity Manager_            | `1.3.1`                                                   | No       |
| nginx_repo_cert                      | _Path to cert required to access the yum/deb repo for NMS_                  | -                                                         | Yes      |
| nginx_repo_key                       | _Path to key required to access the yum/deb repo for NMS_                   | -                                                         | Yes      |
| vsphere_password                     | _The password of the executing vSphere user. _                              | Environment value                                         | No       |
| vsphere_url                          | _The url of the vSphere API. _                                              | Environment value                                         | No       |
| vsphere_username                     | _The name of the executing vSphere user._                                   | Environment value                                         | No       |
