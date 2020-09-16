#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

lock=$HOME/.post-setup.lock
if [ -f "${lock}" ]; then
    echo "Lock file exists. Remove '${lock}' file to re-run post setup."
    exit 0
fi

while [ ! -e "/var/run/mysqld/mysqld.sock" ]; do
    sleep 1
done
sleep 1

file=/home/${DAMP_USER_NAME}/app.sh
if [ -e "${file}" ]; then
    echo "Running custom post setup script ..."
    source ${file}
else
    echo "Custom post setup script '${file}' not found. Skipping ..."
fi

bash /home/${DAMP_USER_NAME}/bin/r-web

touch ${lock}
chmod 400 ${lock}
