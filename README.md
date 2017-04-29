# Docker WP

## Upgrade WordPress

```
docker pull wordpress:php7.1-fpm
docker-compose build
docker-compose stop php && docker-compose rm -v php
docker-compose -f docker-compose.yml -f docker-production.yml up -d
```
