#!/usr/bin/env bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.


export CONSOLE_USERNAME=${CONSOLE_USERNAME:-ubuntu}
export CONSOLE_PASSWORD=${CONSOLE_PASSWORD:-complexPassword1*}
salt=$(head -1 /dev/random | md5sum | awk '{print $1}' | cut -c 1-16)
saltedPassword=$(printf ${CONSOLE_PASSWORD} | openssl passwd -1 -salt ${salt} -stdin)

cat > ./cloud-init/user-data << EOF
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: localhost
    username: ${CONSOLE_USERNAME}
    password: ${saltedPassword}
  ssh:
    allow-pw: yes
    install-server: yes
  storage:
    layout:
      name: direct
  late-commands:
    - 'sed -i "s/dhcp4: true/&\n      dhcp-identifier: mac/" /target/etc/netplan/00-installer-config.yaml'
    - echo "${CONSOLE_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /target/etc/sudoers.d/${CONSOLE_USERNAME}
EOF

packer build $@ nginx.pkr.hcl
