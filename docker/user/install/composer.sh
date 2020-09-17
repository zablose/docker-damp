#!/usr/bin/env bash

set -e

. /usr/local/bin/exit-if-root
. /usr/local/bin/source-env-file

add_composer=${DAMP_ADD_COMPOSER}
add_laravel=${DAMP_ADD_LARAVEL}

user_name=${DAMP_USER_NAME}
group_name=${DAMP_USER_GROUP_NAME}

log=/var/log/damp-composer-install.log

if [[ "$add_composer" != "true" ]]
then
    echo 'Skipping Composer installation ...'
    exit 0
fi

echo 'Installing Composer ...'

composer=$HOME/bin/composer
if [[ ! -f "${composer}" ]]
then
    {
        sudo chmod 700 $HOME/.composer
        sudo chown -R ${user_name}:${group_name} $HOME/.composer
        curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer
        chmod 700 ${composer}
    } | sudo tee ${log} 1>/dev/null
fi

if [[ "${add_laravel}" != "true" ]]
then
    echo 'Skipping Laravel installer installation ...'
    exit 0
fi

laravel=$HOME/.composer/vendor/bin/laravel
if [[ ! -f "${laravel}" ]]
then
    ${composer} global require laravel/installer
    chmod 700 ${laravel}
fi
