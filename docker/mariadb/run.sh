#!/bin/bash

sudo docker rm -f mariadb
# sudo docker run -d --name mariadb fametec/mariadb:latest
sudo docker run -d --name mariadb -v /home/volumes/mariadb:/var/lib/mysql fametec/mariadb:latest
sudo docker logs -f mariadb


