FROM docker.io/centos

ENV VERSION 9.4.4

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV PLUGINS all

RUN curl 'https://setup.ius.io/' | sh 

RUN yum -y install \
		mod_php72u \
		php72u-cli \
		php72u-mysqlnd

RUN yum -y install \
		bzip2 \
		httpd mod_ssl \
		php72u-json \
		php72u-mbstring \
		php72u-mysqli \
		php72u-session \
		php72u-gd \
		php72u-curl \
		php72u-domxml \
		php72u-imap \
		php72u-ldap \
		php72u-openssl \
		php72u-opcache \
		php72u-apcu \
		php72u-xmlrpc \
		php72u-intl \
		openssl \
		jq \
		php-pear-CAS \
		mariadb \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

ADD configure.sh backup.sh plugins.sh /

RUN chmod 755 /configure.sh /backup.sh /plugins.sh

VOLUME ["/var/www/html"]

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]

