#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

file=/home/${DAMP_USER_NAME}/app.sh
if [ -e "${file}" ]; then
    echo "Running custom post setup script ..."
    source ${file}
else
    echo "Custom post setup script '${file}' not found. Skipping ..."
fi

bash /home/${DAMP_USER_NAME}/bin/r-web
