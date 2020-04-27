#!/usr/bin/env bash

set -ev

tee -a /etc/bash.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]\h\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

# Aliases for all users.
alias ls='ls --color --group-directories-first'
alias ll='ls -al --color --group-directories-first'
alias top='htop'

PATH=\$PATH:/home/${ARG_USER_NAME}/bin
PATH=\$PATH:/home/${ARG_USER_NAME}/.composer/vendor/bin

EOF

tee -a /etc/skel/.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -ne 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;93m\]\u\[\033[0;90m\]@\[\033[2;92m\]\h\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;93m\]\\$\[\033[00m\] '
fi

EOF

tee -a /etc/vim/vimrc <<EOF

let g:skip_defaults_vim = 1
syntax on
set background=dark

EOF

echo ${ARG_TIMEZONE} > /etc/timezone && \
rm /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata

echo "root:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd
