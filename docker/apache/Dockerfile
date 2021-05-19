FROM centos:7

MAINTAINER eduardo@fametec.com.br

ENV VERSION 9.5.5

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

WORKDIR /var/www/html

RUN yum -y install epel-release yum-utils

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum-config-manager --enable remi-php73

RUN yum -y install \
		bzip2 \
		httpd \
		php \
		php-common \
		php-mcrypt \
		php-cli \
		php-gd \
		php-mysqlnd \
		php-json \
		php-mbstring \
		php-mysqli \
		php-session \
		php-gd \
		php-curl \
		php-domxml \
		php-imap \
		php-ldap \
		php-openssl \
		php-opcache \
		php-apcu \
		php-xmlrpc \
		php-intl \
		php-zip \
		php-pear-CAS \
		php-ZendFramework-Cache-Backend-Apc \
		php-sodium \
		php-pecl-zip \
	&& yum -y clean all

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

# COPY --chown=apache:apache src/glpi /var/www/html

ADD https://github.com/glpi-project/glpi/releases/download/9.5.5/glpi-9.5.5.tgz /tmp/
#
RUN tar -zxf /tmp/glpi-9.5.5.tgz -C /tmp/ \
	&& mv /tmp/glpi/* /var/www/html/ \
	&& chown -R apache:apache /var/www/html \
	&& rm -rf /tmp/glpi-9.5.5.tgz

VOLUME [ "/var/www/html/files", "/var/www/html/plugins" ]

ADD scripts/glpi-entrypoint.sh scripts/plugins.sh /

RUN chmod 755 /glpi-entrypoint.sh /plugins.sh \
	&& rm -rf /var/www/html/install/install.php

EXPOSE 80/tcp 

CMD ["/glpi-entrypoint.sh"]
