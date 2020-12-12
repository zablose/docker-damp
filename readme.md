# Docker DAMP

Dockerized development environment based on Debian 10.7 with Apache 2.4, MariaDB 10.3 and PHP 7.4.

With some extras:
* composer - Dependency manager for PHP.
* laravel - Laravel installer.
* npm - Node package manager.
* google-chrome - Web browser to run Laravel Dusk tests.

## Usage

### Run Docker-DAMP

    $ git clone https://github.com/zablose/docker-damp.git
    $ cd docker-damp
    $ cp .env.example .env
    $ docker-compose -p zdev up -d

Visit [https://localhost:44300/](https://localhost:44300/) to see output of `phpinfo()` command.

### As Git Submodule

    # Inside your project root.
    $ git submodule add https://github.com/zablose/docker-damp.git
    $ cp docker-damp/docker-compose-example.yml docker-compose.yml

Amend `docker-compose.yml` to your needs.
Replace the prefix `project` with your project name.

    $ cp docker-damp/.env.example .env

Add missing data to `.env` file.
If your project has `.env` file, copy `DAMP_*` envs over.

    $ docker-compose -p zdev up -d

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

Append to `/etc/hosts`:

```
127.0.0.1       docker-damp.zdev
127.0.0.1       www.docker-damp.zdev
```

Use [https://project.zdev:44300/](https://project.zdev:44300/) to access web from your host system.

## Env

> ENVs `DAMP_USER_GROUP_ID`, `DAMP_USER_GROUP_NAME`, `DAMP_USER_ID` and `DAMP_USER_NAME` are used to avoid
> problems, when some files modified inside or outside container and no longer accessible from host system or container.

| Name | Example | Comment |
| --- | --- | --- |
| DAMP_ADD_CHROME | false | Adds Google Chrome with driver into container, if set to `true`, to be used by Laravel Dusk. |
| DAMP_ADD_COMPOSER | true | Adds Composer into container if set to `true`. |
| DAMP_ADD_LARAVEL | false | Adds Laravel installer if set to `true` and Composer was added. |
| DAMP_ADD_NODEJS | false | Installs Node.js with npm if set to `true`. |
| DAMP_DB_NAME | damp | Database name. |
| DAMP_DB_USER | damp | Database username. |
| DAMP_DB_PASSWORD | '' | For all users excluding root. Root has no password with access via socket only. |
|  |  | Quotes are important. Won't work without in some cases, if complex password with special characters is in use. |
| DAMP_LOG | /var/log/damp.log | Log file name inside container. |
| DAMP_PORT_DB | 33060 | Port used to connect to the database from your host system. |
| DAMP_PORT_HTTP | 18000 |  |
| DAMP_PORT_HTTPS | 44300 |  |
| DAMP_PORT_SYSLOG | 51400 |  |
| DAMP_TIMEZONE | Europe/London | Sets timezone for Debian and PHP. |
| DAMP_USER_GROUP_ID | 1000 | User `www-data` will be added to that group to get write access to some folders. |
| DAMP_USER_GROUP_NAME |  | Group name on your host system. |
| DAMP_USER_ID | 1000 | User ID on your host system. |
| DAMP_USER_NAME |  | User name you use on your host system. Must deffer from DB user. Used to create DB user with root privileges and as user for web folders. |
| DAMP_WEB_DOMAIN | docker-damp.zdev | Domain name of your project. Used to setup Apache and generate self-signed certificates. |
| DAMP_WEB_DIR | /home/web | Directory for Apache configuration. |
| DAMP_WEB_APP | /home/web/project | Used by `r-web` script to restore permissions of the Laravel project. |
| DAMP_WEB_ROOT | /home/web/project/public | Document root for Apache configuration. |

## Goodies

### Post Script

> All variables from `.env` will be available inside the script.

Custom script will be executed at the end of the container setup, if mounted to `/home/${DAMP_USER_NAME}/post-setup.sh`.
Setup runs only once, unless lock file removed.

Look at [post-setup.example.sh](./post-setup.example.sh) for an example.

### Logs

> On successful container creation last message will be `Waiting for termination signal to stop container gracefully.`.

Check `./logs/` folder.

    $ tail -f logs/zablose-damp.log
    
    Or
    
    $ tail -f logs/all.log

Other logs to look at inside the container:

| File | Comment |
| --- | --- |
| `/var/log/damp-chrome-driver-install.log` |  |
| `/var/log/damp-chrome-install.log` |  |
| `/var/log/damp-image-build.log` |  |
| `/var/log/damp.log` | Same as 'logs/zablose-damp.log' on the host. |

### Scripts

> Get into container first.

* `lara-clean` or `lara-clean --full` to do cleanup for current Laravel project;
* `r-web` to restore permissions for web folder recursively;
* `xdebug-on`
* `xdebug-off`

## Docker

| Command | Description |
| --- | --- |
| docker exec -it docker-damp-damp bash | Get into container, running Bash shell. |
| docker ps -a | List all containers. |

## Hints

| Command | Description |
| --- | --- |
| sudo su - | Switch to root. |

## License

This package is free software distributed under the terms of the MIT license.
