FROM centos:7

MAINTAINER eduardo@fametec.com.br

ENV VERSION 9.4.5

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV PLUGINS all

WORKDIR /var/www/html

# RUN curl --progress 'https://setup.ius.io/' | sh 

RUN yum -y install epel-release yum-utils

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum-config-manager --enable remi-php73

#RUN yum -y install \
#		mod_php72u \
#		php72u-cli \
#		php72u-mysqlnd

RUN yum -y install \
		php \
		php-common \
		php-mcrypt \
		php-cli \
		php-gd \
		php-mysqlnd \
		bzip2 \
		httpd \
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
		jq \
		php-pear-CAS \
		php-ZendFramework-Cache-Backend-Apc \
	&& yum -y clean all

ADD php.d /etc/php.d
ADD conf.d /etc/httpd/conf.d

COPY --chown=apache:apache src/glpi /var/www/html

VOLUME ["/var/www/html/config", "/var/www/html/files", "/var/www/html/plugins"]

ADD glpi-entrypoint.sh plugins.sh /

RUN chmod 755 /glpi-entrypoint.sh /plugins.sh \
	&& rm -rf /var/www/html/install/install.php

EXPOSE 80/tcp 

CMD ["/glpi-entrypoint.sh"]

