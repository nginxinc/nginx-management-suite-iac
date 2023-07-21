# NGINX Management Suite Image Deployment

This repo contains the templates and scripts that can be used to deploy an NGINX Management Suite image.

## Requirements

- Linux build environment, e.g. ubuntu-22.04
- You must have generated the appropriate cloud images/machines using our [packer guide](../packer/README.md).
- An NGINX Management Suite license. This can be downloaded from [my.f5.com](my.f5.com).
- [Terraform >= 1.2](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- curl >= 7.68
- jq >= 1.6
- apache2-utils/httpd-utils >= 2.4 (Required for htpasswd)

## How to Use

Follow the README in the relevant directory

- [Reference Architecture AWS](basic-reference/aws/README.md)
- [Standalone - Control Plane AWS](standalone/nms/aws/README.md)
- [Standalone - Control Plane GCP](standalone/nms/gcp/README.md)
- [Standalone - Control Plane Azure](standalone/nms/azure/README.md)
- [Standalone - Control Plane VSphere](standalone/nms/vsphere/README.md)
