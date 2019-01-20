FROM fametec/glpi

RUN yum -y install cronie
 
ADD crontab /etc/crontab

VOLUME ["/var/www/html"]

CMD [ "crond", "-s", "-x", "bit", "-n", "/etc/crontab" ]
