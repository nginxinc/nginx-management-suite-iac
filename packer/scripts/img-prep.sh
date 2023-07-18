#!/usr/bin/env bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.

source /etc/os-release

# - clear installer cloud-init config
sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg

if [ "${ID_LIKE}" = "debian" ]; then
    # - apt-daily can cause untimely dpkg lock issues during deployments
    sudo systemctl disable --now apt-daily.timer
    sudo systemctl disable --now apt-daily-upgrade.timer

    # - disable automatic updates
    sudo apt-get purge -y unattended-upgrades

    # - update all packages (eg. to pick up security fixes)
    # - workaround expired mirrors (Release is expired error)
    sudo apt-get -o Acquire::Check-Valid-Until=false update
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get upgrade -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        conntrack \
        curl \
        ebtables \
        iproute2 \
        jq \
        less \
        openssl \
        sed \
        socat \
        wget \
        rsync
    sudo apt-get clean

    if [ -f /var/run/reboot-required ]; then
        sudo reboot
    fi

    sudo needrestart -r a
else
    sudo yum -y update
    sudo yum -y install \
        conntrack \
        ebtables \
        jq \
        socat \
        wget
    sudo yum clean all
fi
