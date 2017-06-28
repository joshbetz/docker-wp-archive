# Docker WP

## Prerequisites

* Docker Engine
* Docker Compose
* Docker Machine

These can be installed using your system's native package manager or from binaries/installers. See the [Docker docs](https://docs.docker.com/engine/installation/) for details.

## Installation

Clone this repo to the directory you want to use as the root of your site:
```
git clone git@github.com:joshbetz/docker-wp.git my-site
cd my-site
```

Make sure Docker is running then:
```
./bin/up
```
Once that completes, go to `http://localhost:8000/` to install WordPress.

## Upgrade WordPress

```
docker pull wordpress:php7.1-fpm
docker-compose build
docker-compose stop php && docker-compose rm -v php
docker-compose -f docker-compose.yml -f docker-production.yml up -d
```
