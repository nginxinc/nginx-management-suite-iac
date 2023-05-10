#!/bin/bash

user=$1
host=$2
private_key=$3
max_attempts=20
attempt=0

while [ $attempt -lt $max_attempts ]
do
  sshpass ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=240 -i $private_key $user@$host 'echo SSH connection successful' && exit 0
  attempt=$((attempt + 1))
  sleep 25
done

echo "SSH connection failed"
exit 1
