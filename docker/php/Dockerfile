FROM php:7.4.10-fpm-alpine

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV VERSION 9.5.4

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# RUN apt-get update \
#   && apt-get install -y --no-install-recommends \
# 	libldap2-dev \
# 	libpng-dev \
# 	libexif-dev \
# 	libxml2-dev \
# 	libc-client-dev \
# 	libkrb5-dev \
#   && apt-get -y clean \
#   && apt-get -y autoremove

#  \
#   libpng \
#   libexif \
#   libxml2 \
#   && apk cache clean

RUN apk add --update --no-cache --virtual .build-dependencies $PHPIZE_DEPS \
        && pecl install apcu \
        && docker-php-ext-enable apcu \
        && pecl clear-cache \
        && apk del .build-dependencies 

RUN apk add --update --no-cache openldap-dev \
    icu-dev \
    libpng-dev \
    libxml2-dev \
    krb5-dev \
    imap-dev \
    autoconf \
  && docker-php-ext-install intl ldap gd exif xmlrpc mysqli opcache \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install imap 

VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins" ]

WORKDIR /usr/share/nginx/html/glpi/

# COPY --chown=www-data:www-data src/glpi /usr/share/nginx/html/glpi

ADD https://github.com/glpi-project/glpi/releases/download/9.5.4/glpi-9.5.4.tgz /usr/share/nginx/html/
#
RUN tar -zxf /usr/share/nginx/html/glpi-9.5.4.tgz -C /usr/share/nginx/html/ \
	&& chown -R www-data:www-data /usr/share/nginx/html/glpi 

COPY scripts/glpi-entrypoint.sh /

RUN chmod +x /glpi-entrypoint.sh \
  && rm -rf /usr/share/nginx/html/glpi/install/install.php

RUN echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/glpi/info.php

EXPOSE 9000/tcp

CMD [ "/glpi-entrypoint.sh" ]
