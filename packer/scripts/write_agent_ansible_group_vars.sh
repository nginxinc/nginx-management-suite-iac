#!/bin/bash

# Copyright (c) F5, Inc.
#
# This source code is licensed under the Apache License, Version 2.0 license found in the
# LICENSE file in the root directory of this source tree.

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
