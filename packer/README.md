# NGINX Management Suite Image Generation

This repo contains the templates and scripts that can be used to generate a NGINX Management Suite Control Host image.

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
```

- Install sshpass

```
    sudo apt-get install sshpass #Required for running of ansible playbook
```

- [packer >= 1.8](https://developer.hashicorp.com/packer/downloads)

```shell
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer
```

And install the required ansible collections

```shell
    cd ansible
    ansible-galaxy install -r requirements.yml
```

## How to Use

Follow the README in the relevant directory to create images/machines.

- [NGINX Management Suite Control Host AWS](nms/aws/README.md)
- [NGINX Management Suite Control Host GCP](nms/gcp/README.md)
- [NGINX Management Suite Control Host Azure](nms/azure/README.md)
- [NGINX Management Suite Control Host vSphere](nms/vsphere/README.md)
- [NGINX Agent AWS](agent/aws/README.md)
