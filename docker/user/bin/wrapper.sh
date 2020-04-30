#!/usr/bin/env bash

set -e

{
    bash $HOME/setup/setup.sh && \
    sudo /etc/init.d/mysql start && \
    sudo /etc/init.d/apache2 start
} | tee -a ${ZDAMP_LOG} 2>&1

tail -f ${ZDAMP_LOG}

exit 0
