FROM fametec/glpi:9.4.4

RUN dnf -y install cronie
 
ADD crontab /etc/crontab

RUN chmod 0644 /etc/crontab

VOLUME ["/var/www/html"]

ENTRYPOINT [ "crond", "-s", "-x", "bit", "-n", "/etc/crontab" ]
