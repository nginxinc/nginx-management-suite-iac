#!/usr/bin/env bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.

set -exo pipefail

# - empty the machine-id file so it can be re-populated at VM boot time
# - we do this to ensure netplan doesn't get confused and cause cloned VMs
#   to get the same ip address assigned to them by dhcp (because they had the
#   same DUID)
duid_file="/etc/machine-id"
if [ -e "$duid_file" ]; then
    sudo rm "$duid_file"
    sudo touch "$duid_file"
fi

