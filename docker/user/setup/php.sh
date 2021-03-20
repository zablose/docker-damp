#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

update()
{
    sudo sed -i -e 's/^error_reporting\s.*$/error_reporting = E_ALL/' $1
    sudo sed -i -e 's/^display_errors\s.*$/display_errors = On/' $1
    sudo sed -i -e 's/^display_startup_errors\s.*$/display_startup_errors = On/' $1
    sudo sed -i -e "s~^;error_log\s=\ssyslog$~error_log = ${DAMP_LOG}~" $1
    sudo sed -i -e "s~^;date.timezone.*$~date.timezone = \"${DAMP_TIMEZONE}\"~" $1

    sudo tee -a $1 <<EOF

[xdebug]
xdebug.remote_autostart=1
xdebug.remote_enable=1
xdebug.remote_host=`route | awk '/^default/ { print \$2 }'`
EOF
}

update /etc/php/7.4/apache2/php.ini
update /etc/php/7.4/cli/php.ini

sudo phpdismod xdebug
