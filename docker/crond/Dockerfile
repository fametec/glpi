FROM fametec/glpi:9.4.1.1

RUN yum -y install cronie
 
ADD crontab /etc/crontab

RUN chmod 0644 /etc/crontab

VOLUME ["/var/www/html"]

ENTRYPOINT [ "crond", "-s", "-x", "bit", "-n", "/etc/crontab" ]
