FROM wordpress:php7.1-fpm

# Install memcached for PHP 7
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl

RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz

COPY .docker/php.ini /usr/local/etc/php/conf.d/wordpress.ini

COPY .docker/wp-config.php /usr/src/wordpress
VOLUME /usr/src/wordpress
WORKDIR /usr/src/wordpress

# Install wp-cli
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
	&& chmod +x /usr/local/bin/wp

RUN apt-get update && apt-get install -y mariadb-client && rm -rf /var/lib/apt/lists/*
COPY .docker/install-multisite /usr/local/bin/install-multisite
CMD /usr/local/bin/install-multisite
