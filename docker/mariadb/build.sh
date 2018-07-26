#!/bin/bash

sudo docker build --rm -t fameconsultoria/mariadb-glpi:latest .


sudo docker rm -f mariadb
sudo docker run -d --name mariadb fameconsultoria/mariadb-glpi:latest
sudo docker logs -f mariadb


