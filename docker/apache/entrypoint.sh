#!/bin/bash
#
# 
if [ -d /var/www/html/glpi ]; then
  echo "Directory found, not to do..."
  rm -rf /tmp/glpi
else
  echo "Directory not found, creating..." 
  mv /tmp/glpi /var/www/html/
  chown -Rf apache:apache /var/www/html/glpi 
fi
#
if [ -e /var/www/html/glpi/config/config_db.php ]; then
  echo "DB Already installed (see --force option)" 
else
  echo "Deploy DB with cliinstall.php. This procedure delay 10 minutes. Please wait..." 
  cd /var/www/html/glpi/scripts && php cliinstall.php \
	--host=$MARIADB_PORT_3306_TCP_ADDR \
	--db=$MARIADB_ENV_MYSQL_DATABASE \
	--user=$MARIADB_ENV_MYSQL_USER \
	--pass=$MARIADB_ENV_MYSQL_PASSWORD \
	--lang=$GLPI_LANG
  if [ $? -eq 0 ]; then
   rm -rf /var/www/html/glpi/install/install.php; 
  fi
fi

mv /tmp/config_db.php /var/www/html/glpi/config/
chown -Rf apache:apache /var/www/html/glpi 

httpd -D FOREGROUND
