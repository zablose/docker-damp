#!/usr/bin/env sh

set -e

tee -a /etc/bash.bashrc <<EOF

# Aliases for all users.
alias ls='ls --color --group-directories-first'
alias ll='ls -al --color --group-directories-first'
alias top='htop'

EOF

tee -a /etc/vim/vimrc <<EOF

let g:skip_defaults_vim = 1
syntax on
set background=dark
set tabstop=4
set expandtab

EOF

echo "root:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd
