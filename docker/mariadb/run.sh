#!/bin/bash

docker rm -f mariadb-glpi
docker volume create mariadb-glpi-volume
# sudo docker run -d --name mariadb fametec/mariadb:latest
docker run -d --name mariadb-glpi -v mariadb-glpi-volume:/var/lib/mysql fametec/mariadb-glpi
docker logs -f mariadb-glpi


