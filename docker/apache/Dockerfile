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
		httpd \
		php \
		php-pear \
		php-json \
		php-mbstring \
		php-mysqli \
		php-session \
		php-gd \
		php-curl \
		php-domxml \
		php-ldap \
		php-opcache \
		php-apcu \
		php-xmlrpc \
		php-intl \
		jq \
		mariadb \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

ADD configure.sh backup.sh plugins.sh /

RUN chmod 755 /configure.sh /backup.sh /plugins.sh

VOLUME ["/var/www/html"]

EXPOSE 80/tcp

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]

