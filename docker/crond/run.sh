#!/bin/bash

docker rm -f crond
docker run -d --name crond --link mariadb-glpi:mariadb-glpi --volume glpi-volume:/var/www/html fametec/crond-glpi
docker logs -f crond
