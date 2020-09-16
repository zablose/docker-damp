#!/usr/bin/env bash

set -e

cd ${DAMP_WEB_APP}

echo 'Some custom post setup actions ...'

mysql -V
sudo mysql -e 'show databases;'
