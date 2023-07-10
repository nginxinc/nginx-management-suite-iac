#!/bin/bash

set -eo pipefail

user=$1
host=$2
private_key=$3

# This step should be deleted once App Delivery Manager resolve their Systemd dependancie in a future release - (NMS-43384)
sshpass ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=240 -i $private_key $user@$host bash << 'EOF'
set -eo pipefail
 
if systemctl list-units --full --all | grep 'nms-adm.service'; then
    echo "Service 'nms-adm' is present. Restarting now..."
    sudo systemctl restart nms-adm
fi
EOF
exit 0