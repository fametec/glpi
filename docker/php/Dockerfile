FROM php:7.3-fpm

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV VERSION 9.4.5

WORKDIR /usr/share/nginx/html

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

VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins", "/usr/share/nginx/html/glpi/config" ]

# COPY --chown=www-data:www-data src/glpi /usr/share/nginx/html/glpi

ADD https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz /usr/share/nginx/html/

RUN tar -zxf glpi-$VERSION.tgz \
 	&& chown -R www-data:www-data /usr/share/nginx/html/glpi \
	&& rm -rf glpi-$VERSION.tgz

RUN {   \
        echo "<?php"; \
        echo "class DB extends DBmysql {"; \
        echo "   public \$dbhost     = \"${MARIADB_HOST}\";"; \
        echo "   public \$dbport     = \"${MARIADB_PORT}\";"; \
        echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
        echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
        echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
        echo "}"; \
    } > /usr/share/nginx/html/glpi/config/config_db.php \
	&& chown www-data:www-data /usr/share/nginx/html/glpi/config/config_db.php


RUN echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/glpi/info.php

EXPOSE 9000/tcp

ENTRYPOINT ["php-fpm"]

