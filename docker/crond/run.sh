#!/bin/bash

docker rm -f crond
docker run -d --name crond --link mariadb:mariadb --volume glpi:/var/www/html fametec/crond
docker logs -f crond
