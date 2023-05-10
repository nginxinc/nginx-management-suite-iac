#!/bin/bash

set -exo pipefail

CERT_PATH=${1}
KEY_PATH=${2}
VERSION=${3}
EMBEDDED_PG=${4}

mkdir -p ../../ansible/group_vars
cat > ../../ansible/group_vars/devportal.yaml <<EOL
---
devportal_log_level: "info"
nginx_type: plus
nginx_license: 
  certificate: ${CERT_PATH}
  key: ${KEY_PATH}
nginx_modules:
  - njs
devportal_version: ${VERSION}
nginx_start: false
devportal_start: false
devportal_db_type: "psql"
devportal_embedded_pg: ${EMBEDDED_PG}
postgresql_databases:
  - name: devportal
postgresql_users:
  - name: nginx-devportal
    password: nginx-devportal
postgresql_hba_entries:
  - {type: local, database: devportal, user: all, auth_method: md5}
  - {type: local, database: all, user: postgres, auth_method: peer}
  - {type: local, database: all, user: all, auth_method: peer}
  - {type: host, database: all, user: all, address: '127.0.0.1/32', auth_method: "{{ postgresql_auth_method }}"}
  - {type: host, database: all, user: all, address: '::1/128', auth_method: "{{ postgresql_auth_method }}"}
EOL
