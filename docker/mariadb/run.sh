#!/bin/bash

docker rm -f mariadb
# sudo docker run -d --name mariadb fametec/mariadb:latest
docker run -d --name mariadb -v /home/volumes/mariadb:/var/lib/mysql fametec/mariadb:latest
docker logs -f mariadb


