#!/bin/bash
#
docker rm -f glpi
#
# docker volume create glpi-volume
#
docker run -d --name glpi --link mariadb-glpi:mariadb -e VERSION=9.4.4 fametec/glpi:latest
#
# docker run -d --name glpi --link mariadb:mariadb --volume glpi-volume:/var/www/html fametec-local/glpi
#
#docker run -d \
#--name glpi \
#--link mariadb-glpi:mariadb-glpi \
#--volume glpi-volume:/var/www/html \
#-e GLPI_LANG=pt_BR \
#-e MARIADB_HOST=mariadb-glpi \
#-e MARIADB_DATABASE=glpi \
#-e MARIADB_USER=glpi \
#-e MARIADB_PASSWORD=glpi \
#-e VERSION=9.4.4 \
#fametec/glpi

docker logs -f glpi
