#!/bin/bash

set -eo pipefail

PLATFORM_URL=$1
PLATFORM_LICENSE_FILE=$2
PLATFORM_ADMIN_USER=$3
PLATFORM_ADMIN_PASS=$4
PLATFORM_CREDENTIALS="${PLATFORM_ADMIN_USER}:${PLATFORM_ADMIN_PASS}"
RETRIES=0
MAX_RETRIES=20


LICENSE_STATUS=null
while [[ "${LICENSE_STATUS}" == "null" ]] && [[ "${RETRIES}" -lt "${MAX_RETRIES}" ]]; do
    echo "Checking license status via platform /api/platform/v1/license api"
    LICENSE_STATUS=$(curl -ks -u "${PLATFORM_CREDENTIALS}" "${PLATFORM_URL}/api/platform/v1/license" || echo "curl_error")
    if [ "${LICENSE_STATUS}" != "curl_error" ]; then
        LICENSE_STATUS=$(echo "${LICENSE_STATUS}" | jq -r .currentStatus.state.currentInstance.status)
    else
        echo "curl error occurred, retrying..."
        LICENSE_STATUS="null"
        RETRIES=$((RETRIES+1))
    fi
    echo "LICENSE_STATUS=${LICENSE_STATUS}"
    sleep 20
done

if [[ "${RETRIES}" -eq "${MAX_RETRIES}" ]]; then
    echo "Reached max retries for setting license file, exiting..."
    exit 1
fi

if [ "${LICENSE_STATUS}" == "NONE" ]; then
    echo "applying license..."
    B64_LIC=$(cat "${PLATFORM_LICENSE_FILE}" | base64)
    echo '{"metadata": {"name": "license"}, "desiredState": {"content": ""}}' | jq ".desiredState.content = \"${B64_LIC}\"" > lic.json
    curl -k -u "${PLATFORM_CREDENTIALS}" \
        -H "Nginx-Management-Suite-User:admin" \
        -H "Content-Type: application/json" \
        -XPUT "${PLATFORM_URL}"/api/platform/v1/license -d @lic.json
    rm lic.json
else
    echo "Not applying license as LICENSE_STATUS != NONE: ${LICENSE_STATUS}"
fi
