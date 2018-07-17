#!/bin/bash

sudo docker build --rm -t fameconsultoria/apache-glpi:latest .


sudo docker rm -f glpi
# sudo docker run -it --name glpi --link mariadb:mariadb fameconsultoria/apache-glpi php /var/www/html/scripts/cliinstall.php --host=mariadb --db=glpi --user=glpi --pass=glpi --lang=pt_BR
# sudo docker exec -d glpi rm -rf /var/www/html/install/install.php

sudo docker run -d --name glpi --link mariadb:mariadb fameconsultoria/apache-glpi

# for i in `seq 1 10`; do echo -n "$i "; sleep 1; done; echo 

# sudo docker exec -d glpi php /var/www/html/scripts/cliinstall.php --host=mariadb --db=glpi --user=glpi --pass=glpi --lang=pt_BR

# for i in `seq 1 10`; do echo -n "$i "; sleep 1; done

# sudo docker exec -d glpi rm -rf /var/www/html/install/install.php


# sudo docker logs -f glpi

# sudo docker inspect glpi | grep -i ipaddr
