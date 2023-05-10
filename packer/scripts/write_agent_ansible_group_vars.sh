#!/bin/bash

set -exo pipefail

CERT_PATH=${1}
KEY_PATH=${2}

mkdir -p ../../ansible/group_vars
cat > ../../ansible/group_vars/agent.yaml <<EOL
---
nginx_type: plus
nginx_license: 
  certificate: ${CERT_PATH}
  key: ${KEY_PATH}
nginx_modules:
  - njs
nginx_start: false
EOL
