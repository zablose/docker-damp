#!/usr/bin/env bash

set -ev

update()
{
    sed -i -e 's/^error_reporting\s.*$/error_reporting = E_ALL/' $1
    sed -i -e 's/^display_errors\s.*$/display_errors = On/' $1
    sed -i -e 's/^display_startup_errors\s.*$/display_startup_errors = On/' $1
    sed -i -e "s~^;error_log\s=\ssyslog$~error_log = $ZDAMP_LOG~" $1
    sed -i -e "s~^;date.timezone.*$~date.timezone = \"$ARG_TIMEZONE\"~" $1

    tee -a $1 <<EOF

[xdebug]
xdebug.remote_autostart=1
xdebug.remote_enable=1
xdebug.remote_host=`route | awk '/^default/ { print \$2 }'`
EOF
}

update /etc/php/7.4/apache2/php.ini
update /etc/php/7.4/cli/php.ini

phpdismod xdebug
