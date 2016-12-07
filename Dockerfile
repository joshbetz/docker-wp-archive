FROM php:fpm

# install the PHP extensions we need for WordPress
RUN apt-get update && apt-get install -y mariadb-client libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

ENV WORDPRESS_VERSION 4.7
ENV WORDPRESS_SHA1 1e14144c4db71421dc4ed22f94c3914dfc3b7020

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
