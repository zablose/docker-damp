#!/usr/bin/env sh

set -e

file=/etc/mysql/mariadb.conf.d/50-server.cnf
sed -i -e 's/^bind-address\s.*$/#bind-address = 127.0.0.1/' ${file}
sed -i -e "s~^log_error\s.*$~log_error = $ZDAMP_LOG~" ${file}

/etc/init.d/mysql start

mysql --user=root <<EOF

CREATE DATABASE IF NOT EXISTS ${ARG_DB_NAME}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON ${ARG_DB_NAME}.* TO '${ARG_DB_USER}'@'%' IDENTIFIED BY '${ARG_DB_PASSWORD}';

USE mysql;
DELETE FROM user WHERE User='';

GRANT ALL PRIVILEGES ON *.* TO '${ARG_USER_NAME}'@'%' IDENTIFIED BY '${ARG_DB_PASSWORD}' WITH GRANT OPTION;

FLUSH PRIVILEGES;

EOF
