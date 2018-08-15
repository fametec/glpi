FROM docker.io/centos

ENV MYSQL_HOST mariadb
ENV MYSQL_DB glpi
ENV MYSQL_USER glpi
ENV MYSQL_PASSWORD glpi
ENV GLPI_LANG pt_BR

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
	openssh-server \
	cronie
 
RUN yum -y clean all && rm -rf /var/cache/yum

RUN /usr/sbin/sshd-keygen

RUN { \
	echo 'memory_limit = 64M;'; \
	echo 'file_uploads = on ;'; \
	echo 'max_execution_time = 600 ;'; \
	echo 'register_globals = off ;'; \
	echo 'magic_quotes_sybase = off ;'; \
	echo 'session.auto_start = off ;'; \
	echo 'session.use_trans_sid = 0 ;'; \
	echo; \
    } > /etc/php.d/99-glpi.ini

RUN { \
	echo '[Date]'; \
	echo 'date.timezone = America/Fortaleza ; '; \
	echo; \
    } > /etc/php.d/timezone.ini

RUN { \
	echo 'apc.enable_cli=1'; \
	echo ; \
    } >> /etc/php.d/40-apcu.ini

RUN { \
	echo '    <Directory /var/www/html/>'; \
	echo '        Options Indexes FollowSymLinks'; \
	echo '        AllowOverride All'; \
	echo '        Require all granted'; \
	echo '    </Directory>'; \
	echo 'ErrorLog /dev/stderr'; \
	echo 'TransferLog /dev/stdout'; \
	echo; \
    } > /etc/httpd/conf.d/glpi.conf

RUN { \
	echo '*/2 * * * * root cd /var/www/html/front && /usr/bin/php cron.php'; \
	echo '*/5 * * * * root cd /var/www/html/front && /usr/bin/php cron.php --forcequeudnotification'; \
	echo; \
    } > /var/spool/cron/root


RUN { \
	echo '#!/bin/bash'; \
	echo 'if [ -e /var/www/html/install/install.php ]; then'; \
	echo '  echo "Deploy DB with cliinstall.php. This procedure delay 10 minutes. Please wait..." '; \
	echo '  php /var/www/html/scripts/cliinstall.php --host=$MYSQL_HOST --db=$MYSQL_DB --user=$MYSQL_USER --pass=$MYSQL_PASSWORD --lang=pt_BR;';\
	echo '  rm -rf /var/www/html/install/install.php'; \
	echo 'fi'; \
	echo ; \
	echo '/usr/sbin/sshd'; \
	echo 'status=$?'; \
	echo 'if [ $status -ne 0 ]; then'; \
	echo '  echo "Failed to start sshd_process: $status"'; \
	echo '  exit $status'; \
	echo 'fi';  \
	echo ; \
	echo 'crond'; \
	echo 'status=$?'; \
	echo 'if [ $status -ne 0 ]; then'; \
	echo '  echo "Failed to start crond_process: $status"'; \
	echo '  exit $status'; \
	echo 'fi';  \
	echo ; \
	echo 'httpd -D FOREGROUND'; \
	echo 'status=$?'; \
	echo 'if [ $status -ne 0 ]; then'; \
	echo '  echo "Failed to start httpd_process: $status"'; \
	echo '  exit $status'; \
	echo 'fi'; \
	echo ; \
	echo 'while sleep 60; do'; \
	echo '  ps aux |grep sshd |grep -q -v grep'; \
	echo '  PROCESS_1_STATUS=$?'; \
	echo '  ps aux |grep crond |grep -q -v grep'; \
	echo '  PROCESS_2_STATUS=$?'; \
	echo '  ps aux |grep httpd |grep -q -v grep'; \
	echo '  PROCESS_3_STATUS=$?'; \
	echo '  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then'; \
	echo '    echo "One of the processes has already exited."'; \
	echo '    exit 1'; \
	echo '  fi'; \
	echo 'done'; \
	echo; \
    } > /entrypoint.sh && chmod 755 /entrypoint.sh





# RUN sed -i '/session required pam_loginuid.so/d' /etc/pamd.d/crond

ADD https://github.com/glpi-project/glpi/releases/download/9.3.0/glpi-9.3.tgz /var/www/html/


RUN tar -zxf /var/www/html/glpi-9.3.tgz -C /var/www/html/ \
	&& rm -rf /var/www/html/glpi/glpi-9.3.tgz \
	&& mv /var/www/html/glpi/* /var/www/html/ \
	&& chown -Rf apache:apache /var/www/html


VOLUME ["/var/www/html"]

EXPOSE 80/tcp 443/tcp 22/tcp

ENTRYPOINT ["/entrypoint.sh"]

# CMD ["-D", "FOREGROUND"]
