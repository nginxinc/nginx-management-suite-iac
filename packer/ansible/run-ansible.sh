#!/bin/bash
set -eo pipefail

scp ../scripts/debian-img-prep-apt.sh ubuntu@10.146.177.241:

ssh ubuntu@10.146.177.241 "chmod 755 debian-img-prep-apt.sh && ./debian-img-prep-apt.sh"

ansible-playbook -i hosts ./play-nms.yml


