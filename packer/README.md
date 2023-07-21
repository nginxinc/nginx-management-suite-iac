# NGINX Management Suite Image Generation

This repo contains the templates and scripts that can be used to generate a NGINX Management Suite Control Host image.

## Requirements

- Linux build environment, e.g. ubuntu-22.04
- An NGINX Management Suite repo cert and key. This can be downloaded from [my.f5.com](my.f5.com).
- [ansible >= 6.7.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Install sshpass (Debian based platforms only)
- [packer >= 1.8](https://developer.hashicorp.com/packer/downloads)
- Install the required ansible collections

```
   ansible-galaxy install -r ./ansible/requirements.yml
```

## How to Use

Follow the README in the relevant directory to create images/machines.

- [NGINX Management Suite Control Host AWS](nms/aws/README.md)
- [NGINX Management Suite Control Host GCP](nms/gcp/README.md)
- [NGINX Management Suite Control Host Azure](nms/azure/README.md)
- [NGINX Management Suite Control Host vSphere](nms/vsphere/README.md)
- [NGINX AWS](nginx/aws/README.md)
