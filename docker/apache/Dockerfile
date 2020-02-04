FROM centos:7

MAINTAINER eduardo@fametec.com.br

ENV VERSION 9.4.5

ENV GLPI_LANG pt_BR

ENV MARIADB_HOST glpi-mariadb

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
	&& yum -y clean all

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

COPY --chown=apache:apache src/glpi /var/www/html

RUN {   \
        echo "<?php"; \
        echo "class DB extends DBmysql {"; \
        echo "   public \$dbhost     = \"${MARIADB_HOST}\";"; \
        echo "   public \$dbport     = \"${MARIADB_PORT}\";"; \
        echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
        echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
        echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
        echo "}"; \
    } > /var/www/html/config/config_db.php \
	&& chown apache:apache /var/www/html/config/config_db.php

# ADD configure.sh backup.sh plugins.sh /

# RUN chmod 755 /configure.sh /backup.sh /plugins.sh

VOLUME ["/var/www/html/glpi/files", "/var/www/html/glpi/plugins"]

EXPOSE 80/tcp 

CMD ["httpd", "-D", "FOREGROUND"]

