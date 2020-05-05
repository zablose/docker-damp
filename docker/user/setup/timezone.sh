#!/usr/bin/env bash

set -e

echo ${TIMEZONE} | sudo tee /etc/timezone
sudo rm /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
