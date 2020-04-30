#!/usr/bin/env bash

set -e

lock=$HOME/.setup.lock

if [ -f "${lock}" ]; then
    echo "Lock file exists. Remove '${lock}' file to re-run setup."
    exit 0
fi

bash $(dirname $0)/timezone.sh && \
bash $(dirname $0)/apache2.sh && \
bash $(dirname $0)/php.sh

touch ${lock}

exit 0
