#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. ${bin}/exit-if-root
. ${bin}/exit-if-locked
. ${bin}/source-env-file
. ${bin}/wait-for-db-to-start

file=$HOME/post-setup.sh
if [ -e "${file}" ]; then
    echo "Running custom post setup script ..."
    . ${file}
else
    echo "Custom post setup script '${file}' not found. Skipping ..."
fi

bash $HOME/bin/r-web

lock=$HOME/.setup.lock
touch ${lock}
chmod 400 ${lock}
