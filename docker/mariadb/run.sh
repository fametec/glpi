#!/bin/bash

docker rm -f mariadb-glpi
# docker volume create mariadb-glpi-volume
docker run -d --name mariadb-glpi fametec/mariadb-glpi:latest
# docker run -d --name mariadb-glpi -v mariadb-glpi-volume:/var/lib/mysql fametec/mariadb-glpi
docker logs -f mariadb-glpi


