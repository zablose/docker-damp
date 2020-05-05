#!/usr/bin/env bash

set -e

lock=$HOME/.setup.lock

if [ -f "${lock}" ]; then
    echo "Lock file exists. Remove '${lock}' file to re-run setup."
    exit 0
fi

setup=$(dirname $0)
bash ${setup}/timezone.sh
bash ${setup}/apache2.sh
bash ${setup}/php.sh

add=$(dirname $0)
bash ${add}/composer.sh
bash ${add}/nodejs.sh

touch ${lock}
