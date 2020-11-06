#!/usr/bin/env sh

set -e

tee -a /etc/bash.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]\h\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

# Aliases for all users.
alias ls='ls --color --group-directories-first'
alias ll='ls -al --color --group-directories-first'
alias top='htop'

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
set tabstop=4
set expandtab

EOF

echo "root:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd
