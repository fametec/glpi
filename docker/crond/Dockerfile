FROM fametec/glpi:9.5.5

RUN yum -y install cronie mariadb
 
ADD crontab /etc/crontab

ADD crond-entrypoint.sh backup.sh /

RUN chmod 0644 /etc/crontab && chmod 755 /crond-entrypoint.sh /backup.sh

CMD [ "/crond-entrypoint.sh" ]
