#!/bin/bash

docker rm -f glpi
# docker run -d --name glpi --link mariadb:mariadb fametec/glpi:latest
docker run -d --name glpi --link mariadb:mariadb --volume /home/volume/html:/var/www/html fametec/glpi
docker logs -f glpi
