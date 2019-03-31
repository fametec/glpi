FROM fametec/glpi

ENV GLPI_LANG pt_BR
ENV MARIADB_HOST mariadb-glpi
ENV MARIADB_PORT 3307


RUN yum -y install cronie
 
ADD crontab /etc/crontab

VOLUME ["/var/www/html"]

ENTRYPOINT [ "crond", "-s", "-x", "bit", "-n", "/etc/crontab" ]
