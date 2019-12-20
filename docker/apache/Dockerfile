FROM centos:7

ENV VERSION 9.4.5

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST mariadb

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV PLUGINS all

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
		httpd mod_ssl \
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

