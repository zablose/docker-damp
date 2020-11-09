#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. ${bin}/exit-if-root
. ${bin}/exit-if-locked
. ${bin}/source-env-file
. ${bin}/wait-for-db-to-start

domain=${DAMP_WEB_DOMAIN}
user_name=${DAMP_USER_NAME}

sudo tee -a /etc/bash.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]${domain}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

EOF

sudo tee -a /etc/skel/.bashrc /home/${user_name}/.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -ne 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;93m\]\u\[\033[0;90m\]@\[\033[2;92m\]${domain}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;93m\]\\$\[\033[00m\] '
fi

EOF

file=$HOME/post-setup.sh
if [ -e "${file}" ]; then
    echo "Running custom post setup script ..."
    . ${file}
else
    echo "Custom post setup script '${file}' not found. Skipping ..."
fi

bash $HOME/bin/r-web

lock=$HOME/.setup.lock
touch ${lock}
chmod 400 ${lock}
