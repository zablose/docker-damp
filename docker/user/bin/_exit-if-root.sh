#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
    echo 'Do not run this script as root.'
    exit 1
fi
