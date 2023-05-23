# API Connectivity Manager and NGINX Devportal Image Generation

This repo contains the templates and scripts that can be used to generate a API Connectivity Manager image.

## Requirements

- Linux build environment, e.g. ubuntu-22.04
- An NGINX Management Suite repo cert and key. This can be downloaded from [my.f5.com](my.f5.com).

## Getting Started

Install the following software.

- [ansible >= 6.7.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

```shell
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    python3 -m pip install --user ansible
    export PATH=~/.local/bin/:$PATH # Optional - add ansible to path if wanted
    sudo apt-get install sshpass #Required for running of ansible playbook
```

- [packer >= 1.8](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

```shell
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

And install the required ansible collections

```shell
    cd ansible
    ansible-galaxy install -r requirements.yaml
```

## How to Use

Follow the README in the relevant directory to create images/machines.

- [API Connectivity Manager AWS](acm/aws/README.md)
- [API Connectivity Manager GCP](acm/gcp/README.md)
- [API Connectivity Manager Azure](acm/azure/README.md)
- [API Connectivity Manager vSphere](acm/vsphere/README.md)
- [NGINX Devportal AWS](devportal/aws/README.md)
- [NGINX Devportal GCP](devportal/gcp/README.md)
- [NGINX Devportal Azure](devportal/azure/README.md)
- [NGINX Devportal vSphere](devportal/vsphere/README.md)
- [NGINX Agent AWS](agent/aws/README.md)
