#!/usr/bin/env bash

set -ev

user_id=${ARG_USER_ID}
user_name=${ARG_USER_NAME}
group_id=${ARG_GROUP_ID}
group_name=${ARG_GROUP_NAME}

home=/home/${user_name}
bashrc=${home}/.bashrc

r-user()
{
    chown -R ${user_id}:${group_id} ${home}
    reas ${home} 700 600
    reas ${home}/bin 700 700

    file=${home}/.composer/vendor/laravel/installer/laravel
    if [[ -f "$file" ]]; then
        chmod 700 ${file}
    fi
}

groupadd -r -g ${group_id} ${group_name} && \
useradd -m -s /bin/bash -u ${user_id} -g ${group_name} ${user_name} && \
adduser www-data ${group_name} && \
echo "$user_name:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd

file=/etc/sudoers.d/${user_name}
echo "$user_name ALL=(ALL) NOPASSWD: ALL" > ${file} && \
chmod 0440 ${file}

cp /etc/skel/.bashrc ${home}/

{ \
    echo "PATH=\$PATH:/home/$user_name/bin"; \
    echo "PATH=\$PATH:/home/$user_name/.composer/vendor/bin"; \
} | tee -a ${bashrc}

{ \
    echo "alias lara-db-migrate-and-seed='php artisan migrate && php artisan db:seed'"; \
    echo "alias lara-db-fresh-and-seed='php artisan migrate:fresh && php artisan db:seed'"; \
    echo "alias phpunit='php vendor/bin/phpunit'"; \
    echo "alias phpunit-with-xdebug='php -d zend_extension=xdebug.so vendor/bin/phpunit'"; \
} | tee -a ${home}/.bash_aliases

r-user

if [[ ! -f "$home/bin/composer" ]]; then
    sudo -H -u ${user_name} bash \
        -c "curl -sS https://getcomposer.org/installer | php -- --install-dir=$home/bin --filename=composer"
fi

if [[ ! -f "$home/.composer/vendor/bin/laravel" ]]; then
    sudo -H -u ${user_name} bash -c "php $home/bin/composer global require laravel/installer"
fi

r-user
