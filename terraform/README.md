# NGINX Management Suite and NGINX Devportal Image Deployment

This repo contains the templates and scripts that can be used to deploy an NGINX Management Suite image.

## Requirements

- Linux build environment, e.g. ubuntu-22.04
- You must have generated the appropriate cloud images/machines using our [packer guide](../packer/README.md).
- An NGINX Management Suite license. This can be downloaded from [my.f5.com](my.f5.com).

## Getting Started

Install the following software.

- [terraform >= 1.2](https://learn.hashicorp.com/tutorials/terraform/install-cli)

```shell
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```

- curl >= 7.68

```shell
sudo apt-get install curl
```

- sshpass for verifying connections

```shell
sudo apt-get install sshpass
```

**Note:** If wishing to set the license as part of deploy process

- jq >= 1.6

```shell
sudo apt-get install jq
```

- apache2-utils >= 2.4

```shell
sudo apt-get install apache2-utils
```

## How to Use

Follow the README in the relevant directory

- [Reference Architecture AWS](basic-reference/aws/README.md)
- [Standalone - Control Plane AWS](standalone/nms/aws/README.md)
- [Standalone - Control Plane GCP](standalone/nms/gcp/README.md)
- [Standalone - Control Plane Azure](standalone/nms/azure/README.md)
- [Standalone - Control Plane VSphere](standalone/nms/vsphere/README.md)
- [Standalone - NGINX Devportal AWS](standalone/devportal/aws/README.md)
- [Standalone - NGINX Devportal Azure](standalone/devportal/azure/README.md)
- [Standalone - NGINX Devportal GCP](standalone/devportal/gcp/README.md)
