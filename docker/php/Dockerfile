FROM php:7.2-fpm

ENV VERSION 9.4.4

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV PLUGINS all


RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
	libldap2-dev \
	libpng-dev \
	libexif-dev \
	libxml2-dev \
	libc-client-dev \
	libkrb5-dev \
  && apt-get -y clean \
  && apt-get -y autoremove

RUN docker-php-ext-install ldap 

RUN docker-php-ext-install gd 

RUN docker-php-ext-install exif 

RUN docker-php-ext-install xmlrpc

RUN docker-php-ext-install mysqli

RUN docker-php-ext-install opcache

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install imap

RUN pecl install --soft apcu \
  && docker-php-ext-enable apcu 

# RUN docker-php-ext-enable xmlrpc exif gd ldap mysqli opcash imap

VOLUME ["/var/www/html"]

WORKDIR /usr/share/nginx/html

RUN echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/test.php

COPY --chown=www-data:www-data src/ /usr/share/nginx/html

EXPOSE 9000/tcp

ENTRYPOINT ["php-fpm"]

