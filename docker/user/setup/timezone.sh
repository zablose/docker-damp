#!/usr/bin/env bash

set -e

. /home/$(whoami)/bin/_source-env-file

echo ${DAMP_TIMEZONE} | sudo tee /etc/timezone
sudo rm /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
