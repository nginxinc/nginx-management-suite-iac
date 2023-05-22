#!/usr/bin/env bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.

# This script contains basic setup that should be run on all vm-cluster builds

set -exo pipefail

# - add ssh client config
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"
cat <<EOF >"${HOME}/.ssh/config"
ForwardAgent yes
ServerAliveInterval 60
StrictHostKeyChecking no
TCPKeepAlive no
UserKnownHostsFile /dev/null
EOF

# - configure sshd to handle up to 20 conncurrent connections
printf "\nMaxSessions 20\nMaxStartups 20\n" | sudo tee -a /etc/ssh/sshd_config
# - disable ssh password connections
sudo sed -i.bak "/^PasswordAuthentication yes/d" /etc/ssh/sshd_config && sudo rm /etc/ssh/sshd_config.bak
printf "\nPasswordAuthentication no\n" | sudo tee -a /etc/ssh/sshd_config

# - empty the machine-id file so it can be re-populated at VM boot time
# - we do this to ensure netplan doesn't get confused and cause cloned VMs
#   to get the same ip address assigned to them by dhcp (because they had the
#   same DUID)
duid_file="/etc/machine-id"
if [ -e "$duid_file" ]; then
    sudo rm "$duid_file"
    sudo touch "$duid_file"
fi

