#!/bin/bash

user=$1
bastion_host=$2
target_host=$3
private_key=$4
max_attempts=20
attempt=0
ssh_config_name=bastion-ssh-config$$

cat <<EOF > ${ssh_config_name}
Host ${bastion_host}
        IdentityFile ${private_key}
        StrictHostKeyChecking no
        ConnectTimeout 240
EOF

while [ $attempt -lt $max_attempts ]
do
  sshpass ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=240 -i $private_key -F ${ssh_config_name} -J $user@$bastion_host $user@$target_host 'echo SSH connection successful' && rm ${ssh_config_name} && exit 0
  attempt=$((attempt + 1))
  sleep 25
done

rm ${ssh_config_name}
echo "SSH connection failed"
exit 1
