#!/bin/bash

set -exo pipefail

CERT_PATH=${1}
KEY_PATH=${2}
VERSION=${3}

mkdir -p ../../ansible/group_vars
cat > ../../ansible/group_vars/acm.yaml <<EOL
---
nginx_license: 
  certificate: ${CERT_PATH}
  key: ${KEY_PATH}
acm_version: ${VERSION}
nms_service_state: stopped
nginx_start: false
nms_setup: install
nms_modules:
  - name: acm
    version: "${VERSION}*"
EOL
