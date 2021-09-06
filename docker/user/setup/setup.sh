#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. ${bin}/exit-if-root
. ${bin}/exit-if-locked

setup=$HOME/setup
bash ${setup}/timezone.sh
bash ${setup}/mariadb.sh
bash ${setup}/apache2.sh
bash ${setup}/php.sh

install=$HOME/install
bash ${install}/composer.sh
bash ${install}/nodejs.sh
bash ${install}/chromium.sh
