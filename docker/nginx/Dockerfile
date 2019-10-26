FROM centos:latest

ENV VERSION 9.4.4

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV PLUGINS all

RUN dnf -y install epel-release

RUN dnf -y install \
		bzip2 \
		unzip \
		nginx \
		php \
		php-fpm \
		php-pear \
		php-json \
		php-mbstring \
		php-mysqli \
		php-mysqlnd \
		php-session \
		php-gd \
		php-curl \
		php-domxml \
		php-ldap \
		php-opcache \
		php-apcu \
		php-xmlrpc \
		php-intl \
		php-zip \
		jq \
		mariadb \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

#RUN dnf install --skip-broken http://rpms.remirepo.net/enterprise/8/remi/x86_64//php-pear-CAS-1.3.8-1.el8.remi.noarch.rpm

#RUN -sSL https://getcomposer.org/installer | php \
#	&& mv composer.phar /usr/local/bin/composer \
#	&& chmod +x /usr/local/bin/composer

RUN mkdir -p /run/php-fpm/

COPY config/php.d /etc/php.d

COPY config/nginx /etc/nginx

COPY config/php-fpm.conf /etc/

COPY config/php-fpm.d /etc/php-fpm.d

# COPY conf.d /etc/httpd/conf.d

COPY configure.sh backup.sh plugins.sh /

RUN chmod 755 /configure.sh /backup.sh /plugins.sh

VOLUME ["/usr/share/nginx/html"]

COPY --chown=nginx:nginx src/glpi /usr/share/nginx/html/glpi

EXPOSE 80/tcp 9000/tcp

# ENTRYPOINT ["httpd", "-D", "FOREGROUND"]


# Let supervisord start nginx & php-fpm
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
# HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

