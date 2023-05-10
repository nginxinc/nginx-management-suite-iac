#!/usr/bin/env bash
export CONSOLE_PASSWORD=${CONSOLE_PASSWORD:-complexPassword1*}
salt=$(head -1 /dev/random | md5sum | awk '{print $1}' | cut -c 1-16)
saltedPassword=$(printf ${CONSOLE_PASSWORD} | openssl passwd -1 -salt ${salt} -stdin)

cat > ./cloud-init/user-data << EOF
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: localhost
    username: ubuntu
    password: ${saltedPassword}
  ssh:
    allow-pw: yes
    install-server: yes
  storage:
    layout:
      name: direct
  late-commands:
    - 'sed -i "s/dhcp4: true/&\n      dhcp-identifier: mac/" /target/etc/netplan/00-installer-config.yaml'
    - echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/ubuntu
EOF

packer build $@ ubuntu-vsphere-acm.pkr.hcl
