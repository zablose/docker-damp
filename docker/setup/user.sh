#!/usr/bin/env sh

set -e

HOME=/home/${ARG_USER_NAME}
. /usr/local/bin/source-env-file

user_id=${DAMP_USER_ID}
user_name=${DAMP_USER_NAME}
group_id=${DAMP_USER_GROUP_ID}
group_name=${DAMP_USER_GROUP_NAME}
damp_log=${DAMP_LOG}

home=/home/${user_name}
bashrc=${home}/.bashrc

groupadd -r -g ${group_id} ${group_name}
useradd -m -s /bin/bash -u ${user_id} -g ${group_name} ${user_name}
adduser www-data ${group_name}
echo "$user_name:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd

file=/etc/sudoers.d/${user_name}
echo "$user_name ALL=(ALL) NOPASSWD: ALL" > ${file}
chmod 0440 ${file}

cp /etc/skel/.bashrc ${bashrc}

tee -a ${bashrc} <<EOF

PATH=\$PATH:${home}/bin
PATH=\$PATH:${home}/.composer/vendor/bin

EOF

{
    echo "alias lara-db-migrate-and-seed='php artisan migrate && php artisan db:seed'"
    echo "alias lara-db-fresh-and-seed='php artisan migrate:fresh && php artisan db:seed'"
    echo "alias phpunit='php vendor/bin/phpunit'"
    echo "alias phpunit-with-xdebug='php -d zend_extension=xdebug.so vendor/bin/phpunit'"
} | tee ${home}/.bash_aliases

chown -R ${user_id}:${group_id} ${home}
reas ${home} 700 600
reas ${home}/bin 700 700

touch ${damp_log}
chmod 666 ${damp_log}
