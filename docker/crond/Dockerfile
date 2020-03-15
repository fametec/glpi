FROM fametec/glpi:9.4.5

RUN yum -y install cronie
 
ADD crontab /etc/crontab

RUN chmod 0644 /etc/crontab 

VOLUME ["/var/www/html"]

COPY crond-entrypoint.sh /

RUN chmod 755 /crond-entrypoint.sh

CMD [ "crond-entrypoint.sh"" ]
