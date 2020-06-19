#!/usr/bin/env bash

set -e

. /home/$(whoami)/bin/_source-env-file

if [[ "${DAMP_ADD_COMPOSER}" != "true" ]]; then
    echo 'Skipping Composer installation ...'
    exit 0
fi

composer=$HOME/bin/composer
if [[ ! -f "${composer}" ]]; then
    sudo chmod 700 $HOME/.composer
    sudo chown -R $(whoami):$(whoami) $HOME/.composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer
    chmod 700 ${composer}
fi

if [[ "${DAMP_ADD_LARAVEL}" != "true" ]]; then
    echo 'Skipping Laravel installation ...'
    exit 0
fi

laravel=$HOME/.composer/vendor/bin/laravel
if [[ ! -f "${laravel}" ]]; then
    composer global require laravel/installer
    chmod 700 ${laravel}
fi
