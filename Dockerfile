FROM php:fpm

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

# install the PHP extensions we need for WordPress
RUN apt-get update && apt-get install -y mariadb-client libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

# https://wordpress.org/wordpress-4.7.2.tar.gz.sha1
ENV WORDPRESS_VERSION 4.7.2
ENV WORDPRESS_SHA1 7b687f1af589c337124e6247229af209ec1d52c3

RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

COPY .docker/php.ini /usr/local/etc/php/conf.d/wordpress.ini

COPY .docker/wp-config.php /usr/src/wordpress
VOLUME /usr/src/wordpress
WORKDIR /usr/src/wordpress

# Install wp-cli
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
	&& chmod +x /usr/local/bin/wp

COPY .docker/install-multisite /usr/local/bin/install-multisite
CMD /usr/local/bin/install-multisite
