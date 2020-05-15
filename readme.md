# Docker DAMP

Dockerized development environment based on Debian 10.3 with Apache2, MariaDB and PHP 7.4.

With some extras:
* composer - Dependency Manager for PHP
* laravel - Laravel installer
* npm - Node Package Manager

## Usage

### Run Docker-DAMP

    $ git clone https://github.com/zablose/docker-damp.git
    $ cd docker-damp
    $ docker-compose -p zdev up -d

Visit [https://localhost:44300/](https://localhost:44300/) to see output of 'phpinfo()' command.

### As Git Submodule

    # Run this command inside your project root.
    $ git submodule add https://github.com/zablose/docker-damp.git
    $ cp docker-damp/docker-compose.yml .

Amend 'docker-compose.yml' to your needs.
Replace the prefix 'project' with your project name.

ENVs to be aware of:

| Name | Default | Description |
| --- | --- | --- |
| ADD_COMPOSER | true | Adds Composer into container if set to 'true'. |
| ADD_LARAVEL | false | Adds Laravel installer if set to 'true' and Composer was added. |
| ADD_NODEJS | false | Installs Node.js with npm if set to 'true'. |
| APP_ROOT | /home/web | Used by 'r-web' script to restore permissions of the Laravel project. |
| TIMEZONE | Europe/London | Sets timezone for Debian and PHP. |
| WEB_DOMAIN | project.zdev | Domain name of your project. Used to setup Apache and generate self-signed certificates. |
| WEB_ROOT | /home/web/public | Document root for Apache configuration. |

Look at [zablose/captcha](https://github.com/zablose/captcha) for a usage example.

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

Use [https://project.zdev:44300/](https://project.zdev:44300/) to access web from your host system.

## Env

> ENVs `ZDAMP_HOST_USER_ID`, `ZDAMP_HOST_USER_NAME`, `ZDAMP_HOST_GROUP_ID` and `ZDAMP_HOST_GROUP_NAME` are used to avoid
> problems, when some files modified inside or outside container and no longer accessible from host system or container.

| Name | Default | Comment |
| --- | --- | --- |
| ZDAMP_HOST_USER_ID | 1000 | User ID on your host system. |
| ZDAMP_HOST_USER_NAME |  | User name you use on your host system. Must deffer from DB user. Used to create DB user with root privileges and as user for web folders. |
| ZDAMP_HOST_GROUP_ID | 1000 | User `www-data` will be added to that group to get write access to some folders. |
| ZDAMP_HOST_GROUP_NAME |  | Group name on your host system. |
| ZDAMP_DB_NAME | laravel |  |
| ZDAMP_DB_USER | laravel |  |
| ZDAMP_DB_PASSWORD |  | For all users excluding root. Root has no password with access via socket only. |

Append to `~/.bashrc`.

```bash
export \
    ZDAMP_HOST_USER_ID=1000 \
    ZDAMP_HOST_USER_NAME=hostuser \
    ZDAMP_HOST_GROUP_ID=1000 \
    ZDAMP_HOST_GROUP_NAME=hostgroup \
    ZDAMP_DB_PASSWORD=
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
