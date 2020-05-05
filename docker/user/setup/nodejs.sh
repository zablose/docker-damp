#!/usr/bin/env bash

set -e

if [[ "${ADD_NODEJS}" != "true" ]]; then
    echo 'Skipping Node.js installation ...'
    exit 0
fi

file=/etc/apt/sources.list.d/nodesource.list
if [[ ! -f "${file}" ]]; then
    {
        echo 'deb https://deb.nodesource.com/node_12.x buster main'
        echo 'deb-src https://deb.nodesource.com/node_12.x buster main'
    } | sudo tee ${file}

    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add

    sudo apt-get update
    sudo apt-get install -y --no-install-recommends nodejs >> $ZDAMP_LOG
    sudo npm install -g npm
fi
