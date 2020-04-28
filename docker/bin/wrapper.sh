#!/usr/bin/env bash

set -ev

sudo /etc/init.d/mysql start && \
sudo /etc/init.d/apache2 start && \
tail -f ${ZDAMP_LOG}
