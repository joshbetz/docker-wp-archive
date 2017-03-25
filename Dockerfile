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

COPY ./wp-config.php /usr/src/wordpress
VOLUME /usr/src/wordpress
WORKDIR /usr/src/wordpress

# curl -iL https://github.com/wp-cli/wp-cli/releases/download/v1.1.0/wp-cli-1.1.0.phar.md5
ENV WPCLI_VERSION 1.1.0
ENV WPCLI_MD5 5044e6a5e589c786d6e792825bd8fb4a

# Install wp-cli
RUN set -ex; \
	curl -o /usr/local/bin/wp -SL https://github.com/wp-cli/wp-cli/releases/download/v${WPCLI_VERSION}/wp-cli-${WPCLI_VERSION}.phar && \
	echo "$WPCLI_MD5 /usr/local/bin/wp" | md5sum -c - && \
	chmod +x /usr/local/bin/wp
