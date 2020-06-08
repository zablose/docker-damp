#!/usr/bin/env bash

set -e

sudo /etc/init.d/mysql start

while [ ! -e "/var/run/mysqld/mysqld.sock" ]; do
    sleep 1
done
sleep 1

sudo -- mysql <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';

USE mysql;
DELETE FROM user WHERE User='';

GRANT ALL PRIVILEGES ON *.* TO '${USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

sudo /etc/init.d/mysql stop
