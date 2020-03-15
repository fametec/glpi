FROM fametec/glpi:9.4.5

RUN yum -y install cronie mariadb
 
ADD crontab /etc/crontab

ADD crond-entrypoint.sh /

RUN chmod 0644 /etc/crontab && chmod 755 /crond-entrypoint.sh /backup.sh

CMD [ "/crond-entrypoint.sh" ]
