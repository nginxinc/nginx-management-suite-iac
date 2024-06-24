#!/usr/bin/env bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.
set -exo pipefail

source /etc/os-release

if [ "${ID}" = "ubuntu" ]; then
    cloud-init status --wait
fi

if [ "${ID_LIKE}" = "debian" ]; then
    # - clear installer cloud-init config
    sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg

    # - apt-daily can cause untimely dpkg lock issues during deployments
    sudo systemctl disable --now apt-daily.timer
    sudo systemctl disable --now apt-daily-upgrade.timer

    # Update package lists
    sudo apt-get update

    # - disable automatic updates
    sudo apt-get purge -y unattended-upgrades

    # Install needrestart
    sudo apt-get -y install needrestart

    # Configure needrestart to automatically restart services
    echo 'needrestart needrestart/auto-restart-services string all' | sudo debconf-set-selections

    # - update all packages (eg. to pick up security fixes)
    # - workaround expired mirrors (Release is expired error)
    sudo apt-get -o Acquire::Check-Valid-Until=false update
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get upgrade -y
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get -y --no-install-recommends install \
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

    sudo needrestart -r a

    if [ -f /var/run/reboot-required ]; then
        sudo reboot
    fi

else
    # Disable SELinux until nms ansible role supports SELinux
    if [ "$(getenforce)" = "Enforcing" ]; then
        sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
    fi
    sudo yum -y update
    sudo yum clean all
fi
