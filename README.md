# Docker WP

## Getting Started

Before you can start, you'll need to [install Docker](https://docs.docker.com/engine/installation/).

You can install WordPress by running the `bin/up` script. The `wp-content` directory is mapped a level above the `docker-wp` root. This is to make it easier to use this repository as a dependency in another repo.

```
mkdir wordpress.local && cd wordpress.local
git clone --recursive https://github.com/joshbetz/docker-wp.git
docker-wp/bin/up
cd wp-content
open http://localhost:8000
```

Then you'll need to install a theme in `wp-content/themes` and set up WordPress.

## Upgrade WordPress

```
docker-wp/bin/up
```
