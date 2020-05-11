# Docker DAMP

Dockerized development environment based on Debian 10.3 with Apache2, MariaDB and PHP 7.4.

With some extras:
* composer - Dependency Manager for PHP
* laravel - Laravel installer
* npm - Node Package Manager

## Aliases

`~/.bash_aliases`

```bash
alias c-add-key='ssh-add ~/.ssh/id_rsa'

alias d-img-clean='docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")'
alias d-con-remove-all='docker rm $(docker ps -a -q)'
alias d-img-remove-all='docker rmi -f $(docker images -q)'
alias dc-stop='docker-compose -p zdev stop -t 30'
alias dc-up='docker-compose -p zdev up -d'
```

## Hosts

Append to `/etc/hosts` for remote access from Postman, Browser, etc.

```
127.0.0.1       project.zdev
127.0.0.1       www.project.zdev
```

Use `https://project.zdev:44300/` to access web from your host system.

## Env

| Name | Default Value | Comment |
| --- | --- | --- |
| ZDAMP_HOST_USER_ID | 1000 |  |
| ZDAMP_HOST_USER_NAME |  |  |
| ZDAMP_HOST_GROUP_ID | 1000 | User `www-data` will be added to that group to get write access to some folders. |
| ZDAMP_HOST_GROUP_NAME |  |  |
| ZDAMP_DB_NAME | laravel |  |
| ZDAMP_DB_USER | laravel |  |
| ZDAMP_DB_PASSWORD | qwerty | For all users excluding root. |

Append to `~/.bashrc`.

```bash
export \
    ZDAMP_HOST_USER_ID=1000 \
    ZDAMP_HOST_USER_NAME=zablose \
    ZDAMP_HOST_GROUP_ID=1000 \
    ZDAMP_HOST_GROUP_NAME=zablose
```

## Goodies

### Logs

Check `./logs/` folder.

    $ tail -f logs/all.log

### Scripts

> Get into container first.

* `lara-clean` or `lara-clean --full` to do cleanup for current Laravel project;
* `r-web` to restore permissions for web folder recursively;
* `xdebug-on`
* `xdebug-off`

## Docker

| Command | Description |
| --- | --- |
| docker exec -it project-zdev bash | Get into container, running Bash shell. |
| docker ps -a | List all containers. |

## License

This package is free software distributed under the terms of the MIT license.
