#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

file=/etc/mysql/mariadb.conf.d/50-server.cnf
sudo sed -i -e "s~^\(bind-address.*\)$~#\1~" ${file}

sudo /etc/init.d/mysql start

while [ ! -e "/var/run/mysqld/mysqld.sock" ]; do
    sleep 1
done
sleep 1

echo 'Running default SQL ...'

sudo -- mysql <<EOF
CREATE DATABASE IF NOT EXISTS ${DAMP_DB_NAME}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON ${DAMP_DB_NAME}.* TO '${DAMP_DB_USER}'@'%' IDENTIFIED BY '${DAMP_DB_PASSWORD}';

USE mysql;
DELETE FROM user WHERE User='';

GRANT ALL PRIVILEGES ON *.* TO '${DAMP_USER_NAME}'@'%' IDENTIFIED BY '${DAMP_DB_PASSWORD}' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

file=/home/${DAMP_USER_NAME}/db.sql.sh
if [ -e "${file}" ]; then
    echo "Running custom SQL script ..."
    source ${file}
else
    echo "Custom SQL script '${file}' not found. Skipping ..."
fi

sudo /etc/init.d/mysql stop

while [ -e "/var/run/mysqld/mysqld.sock" ]; do
    sleep 1
done
