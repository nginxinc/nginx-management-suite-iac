# NGINX Instance Manager Image Generation

This repo contains the templates and scripts that can be used to generate a NGINX Instance Manager Control Host image.

## Requirements

- Linux build environment, e.g. ubuntu-22.04
- An NGINX Instance Manager repo cert and key. This can be downloaded from [my.f5.com](my.f5.com).
- [ansible >= 6.7.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Install sshpass (Debian based platforms only)
- [packer >= 1.8](https://developer.hashicorp.com/packer/downloads)
- Install the required ansible collections from the packer directory.

```
   ansible-galaxy install -r ./ansible/requirements.yml
```

- Install ansible plugin for packer(https://developer.hashicorp.com/packer/integrations/hashicorp/ansible)

```
   packer plugins install github.com/hashicorp/ansible
```

## How to Use

Follow the README in the relevant directory to create images/machines.

- [NGINX Instance Manager Control Host AWS](nms/aws/README.md)
- [NGINX Instance Manager Control Host GCP](nms/gcp/README.md)
- [NGINX Instance Manager Control Host Azure](nms/azure/README.md)
- [NGINX Instance Manager Control Host vSphere](nms/vsphere/README.md)
- [NGINX AWS](nginx/aws/README.md)
