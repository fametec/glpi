FROM docker.io/centos

ENV GLPI_LANG pt_BR

RUN curl 'https://setup.ius.io/' | sh 
#yum -y install epel-release \
#	&& yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
#	&& rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY 

RUN yum -y install \
		mod_php72u \
		php72u-cli \
		php72u-mysqlnd

RUN yum -y install \
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
		openssl \
		php-pear-CAS \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

ADD installdb.sh /

ADD entrypoint.sh /

# ADD config_db.php /tmp/

RUN chmod 755 /entrypoint.sh /installdb.sh

# wget -c https://github.com/glpi-project/glpi/releases/download/9.3.2/glpi-9.3.2.tgz
# tar -zxvf glpi-9.3.2.tgz

ADD glpi /tmp/glpi 

VOLUME ["/var/www/html"]

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["/entrypoint.sh"]

# CMD ["httpd", "-D", "FOREGROUND"]
