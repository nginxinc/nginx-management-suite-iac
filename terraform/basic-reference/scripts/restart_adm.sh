#!/bin/bash

set -eo pipefail

user=$1
bastion_host=$2
target_host=$3
private_key=$4
ssh_config_name=bastion-ssh-config$$

cat <<EOF > ${ssh_config_name}
Host ${bastion_host}
        IdentityFile ${private_key}
        StrictHostKeyChecking no
        ConnectTimeout 240
EOF

# This step should be deleted once App Delivery Manager resolve their Systemd dependancies in a future release - (NMS-43384)
sshpass ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=240 -i $private_key -F ${ssh_config_name} -J $user@$bastion_host $user@$target_host bash << 'EOF'
set -eo pipefail
 
if systemctl list-units --full --all | grep 'nms-adm.service'; then
    echo "Service 'nms-adm' is present. Restarting now..."
    sudo systemctl restart nms-adm
fi
EOF
rm ${ssh_config_name}
exit 0