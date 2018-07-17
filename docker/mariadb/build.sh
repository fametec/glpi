#!/bin/bash

sudo docker build --rm -t fameconsultoria/mariadb-glpi:latest .


sudo docker stop mariadb
sudo docker rm mariadb

# sudo docker run -it --name glpi-apache fameconsultoria/centos-glpi /bin/bash
sudo docker run -d --name mariadb fameconsultoria/mariadb-glpi:latest

sudo docker logs -f mariadb


