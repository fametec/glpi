FROM docker.io/centos

RUN yum -y update \
	&& yum -y install epel-release \
	&& yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
	&& rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY

RUN yum -y install \
	mod_php70u \
	php70u-cli \
	php70u-mysqlnd 

RUN yum -y install \
	httpd mod_ssl \
	php70u-json \
	php70u-mbstring \
	php70u-mysqli \
	php70u-session \
	php70u-gd \
	php70u-curl \
	php70u-domxml \
	php70u-imap \
	php70u-ldap \
	php70u-openssl \
	php70u-opcache \
	php70u-apcu \
	php70u-xmlrpc \
	openssl \
	php-pear-CAS \
	cronie
 
RUN yum -y clean all

ADD 99-glpi.ini /etc/php.d/
ADD timezone.ini /etc/php.d/
ADD glpi.conf /etc/httpd/conf.d/
ADD https://github.com/glpi-project/glpi/releases/download/9.3.0/glpi-9.3.tgz /var/www/html/

RUN tar -zxf /var/www/html/glpi-9.3.tgz -C /var/www/html/ \
	&& rm -rf /var/www/html/glpi/glpi-9.3.tgz \
	&& mv /var/www/html/glpi/* /var/www/html/ \
	&& chown -R apache:apache /var/www/html


VOLUME ["/var/www/html", "/etc/httpd", "/etc/php.d"]

EXPOSE 80/tcp 443/tcp

# ENTRYPOINT ["php", "/var/www/html/scripts/cliinstall.php", "--host=mariadb", "--db=glpi", "--user=glpi", "--pass=glpi", "--lang=pt_BR"]
# ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
# ENTRYPOINT ["crond"]
ENTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]
