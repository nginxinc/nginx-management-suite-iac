#!/bin/bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.

set -exo pipefail

CERT_PATH=${1}
KEY_PATH=${2}
VERSION=${3}

mkdir -p ../../ansible/group_vars
cat > ../../ansible/group_vars/nms.yaml <<EOL
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
