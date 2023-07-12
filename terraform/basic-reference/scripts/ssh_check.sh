#!/bin/bash

user=$1
bastion_host=$2
target_host=$3
private_key=$4
max_attempts=20
attempt=0

cat <<EOF >bastion-ssh-config
Host ${bastion_host}
        IdentityFile ${private_key}
        StrictHostKeyChecking no
        ConnectTimeout 240
EOF

while [ $attempt -lt $max_attempts ]
do
  sshpass ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=240 -i $private_key -F ./bastion-ssh-config -J $user@$bastion_host $user@$target_host 'echo SSH connection successful' && rm ./bastion-ssh-config && exit 0
  attempt=$((attempt + 1))
  sleep 25
done

rm ./bastion-ssh-config
echo "SSH connection failed"
exit 1
