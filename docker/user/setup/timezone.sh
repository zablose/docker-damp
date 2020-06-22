#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

echo ${DAMP_TIMEZONE} | sudo tee /etc/timezone
sudo rm /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
