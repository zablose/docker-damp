#!/usr/bin/env bash

. $(dirname $0)/_exit-if-root.sh

if [[ "$1" == '--full' ]]
then
    set -ev
    echo '' > storage/logs/laravel.log && \
    rm -rf \
        storage/framework/sessions/* \
        storage/logs/laravel-*.log \
        tests/Browser/console/*.log \
        ./vendor/ \
        composer.lock \
        && \
    composer install
fi

php artisan view:clear && \
php artisan clear-compiled && \
php artisan cache:clear && \
php artisan config:clear && \
php artisan route:clear && \

composer dumpautoload
