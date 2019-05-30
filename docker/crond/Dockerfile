FROM fametec/glpi:latest

RUN yum -y install cronie
 
ADD crontab /etc/crontab

RUN chmod 0644 /etc/crontab

VOLUME ["/var/www/html"]

ENTRYPOINT [ "crond", "-s", "-x", "bit", "-n", "/etc/crontab" ]
