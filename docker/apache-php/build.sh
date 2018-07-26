#!/bin/bash

docker build --rm -t fameconsultoria/apache-glpi:latest .


docker rm -f glpi
docker run -d --name glpi --link mariadb:mariadb fameconsultoria/apache-glpi
docker logs -f glpi
