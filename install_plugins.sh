#!/bin/sh

set -x

cd /var/www/html/glpi/plugins/ 

if [ ! -e Plugin_mod-9.2.2_1.1.7.tar.gz ]; then 
  wget -c https://sourceforge.net/projects/glpithemes/files/9.2.2/Plugin_mod-9.2.2_1.1.7.tar.gz
fi
tar -zxf Plugin_mod-9.2.2_1.1.7.tar.gz


if [ ! -e glpi-archires-2.5.1.tar.gz ]; then 
  wget -c https://forge.glpi-project.org/attachments/download/2235/glpi-archires-2.5.1.tar.gz
fi 
tar -zxf glpi-archires-2.5.1.tar.gz


if [ ! -e GLPI-dashboard_plugin-0.9.0_GLPI-9.2.x.tar.gz ]; then 
  wget -c https://forge.glpi-project.org/attachments/download/2216/GLPI-dashboard_plugin-0.9.0_GLPI-9.2.x.tar.gz
fi 
tar -zxf GLPI-dashboard_plugin-0.9.0_GLPI-9.2.x.tar.gz


if [ ! -e glpi-reports-1.11.2.tar.gz ]; then 
  wget -c https://forge.glpi-project.org/attachments/download/2234/glpi-reports-1.11.2.tar.gz
fi 
tar -zxf glpi-reports-1.11.2.tar.gz


chown -R apache:apache /var/www/html/glpi/plugins



