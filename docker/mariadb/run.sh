#!/bin/bash

docker rm -f mariadb-glpi
# sudo docker run -d --name mariadb fametec/mariadb:latest
docker run -d --name mariadb-glpi -v /home/volumes/mariadb:/var/lib/mysql fametec-local/mariadb-glpi:latest
docker logs -f mariadb-glpi


