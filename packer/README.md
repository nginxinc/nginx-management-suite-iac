# API Connectivity Manager and NGINX Devportal Image Generation

This repo contains the templates and scripts that can be used to generate a API Connectivity Manager image.

## Basic Usage

Prerequisties

- Linux build environment, e.g. ubuntu-22.04
- [ansible >= 6.7.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

```
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    python3 -m pip install --user ansible
    export PATH=~/.local/bin/:$PATH # Optional - add ansible to path if wanted
    sudo apt-get install sshpass #Required for running of ansible playbook
```

- [packer >= 1.8](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

And install the required ansible collections

```
    cd ansible
    ansible-galaxy install -r requirements.yaml
```

Aquire a NMS repo cert and key

Then follow the README in the relevant directory

- [API Connectity Manager AWS](acm/aws/README.md)
- [API Connectity Manager GCP](acm/gcp/README.md)
- [API Connectity Manager Azure](acm/azure/README.md)
- [API Connectity Manager vSphere](acm/vsphere/README.md)
- [NGINX Devportal AWS](devportal/aws/README.md)
- [NGINX Devportal GCP](devportal/gcp/README.md)
- [NGINX Devportal Azure](devportal/azure/README.md)
- [NGINX Devportal vSphere](devportal/vsphere/README.md)
