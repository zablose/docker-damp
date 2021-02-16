#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

add_nodejs=${DAMP_ADD_NODEJS}

log=/var/log/damp-nodejs-install.log

if [[ "${add_nodejs}" != "true" ]]
then
    echo 'Skipping Node.js installation ...'
    exit 0
fi

echo 'Installing Node.js ...'

file=/etc/apt/sources.list.d/nodesource.list
if [[ ! -f "${file}" ]]
then
    {
        echo 'deb https://deb.nodesource.com/node_14.x buster main'
        echo 'deb-src https://deb.nodesource.com/node_14.x buster main'
    } | sudo tee ${file} 1>/dev/null

    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add
fi

file=$(command -v nodejs || echo '')
if [[ -x "${file}" ]]
then
    echo "Command '${file}' exists. Node.js was already installed."
    exit 0
fi

{
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs
    sudo npm install -g npm
} | sudo tee ${log} 1>/dev/null

if [[ -x "$(command -v nodejs || echo '')" && -x "$(command -v npm || echo '')" ]]
then
    echo 'Installation of Node.js is complete.'
else
    echo "Cannot find 'nodejs' or 'npm' command. Check '${log}' for more details."
fi
