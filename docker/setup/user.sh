#!/usr/bin/env sh

set -e

user_id=${ARG_USER_ID}
user_name=${ARG_USER_NAME}
group_id=${ARG_GROUP_ID}
group_name=${ARG_GROUP_NAME}

home=/home/${user_name}
bashrc=${home}/.bashrc

groupadd -r -g ${group_id} ${group_name}
useradd -m -s /bin/bash -u ${user_id} -g ${group_name} ${user_name}
adduser www-data ${group_name}
echo "$user_name:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd

file=/etc/sudoers.d/${user_name}
echo "$user_name ALL=(ALL) NOPASSWD: ALL" > ${file}
chmod 0440 ${file}

cp /etc/skel/.bashrc ${home}/

{
    echo "alias lara-db-migrate-and-seed='php artisan migrate && php artisan db:seed'"
    echo "alias lara-db-fresh-and-seed='php artisan migrate:fresh && php artisan db:seed'"
    echo "alias phpunit='php vendor/bin/phpunit'"
    echo "alias phpunit-with-xdebug='php -d zend_extension=xdebug.so vendor/bin/phpunit'"
} | tee ${home}/.bash_aliases

chown -R ${user_id}:${group_id} ${home}
reas ${home} 700 600
reas ${home}/bin 700 700
