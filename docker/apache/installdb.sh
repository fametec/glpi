#!/bin/bash
if [ -e /var/www/html/glpi/install/install.php ]; then
  echo "Deploy DB with cliinstall.php. This procedure delay 10 minutes. Please wait..." 
  php /var/www/html/glpi/scripts/cliinstall.php \
	--host=$MARIADB_PORT_3306_TCP_ADDR \
	--db=$MARIADB_ENV_MYSQL_DATABASE \
	--user=$MARIADB_ENV_MYSQL_USER \
	--pass=$MARIADB_ENV_MYSQL_PASSWORD \
	--lang=$GLPI_LANG
  if [ $? -eq 0 ]; then
   rm -rf /var/www/html/glpi/install/install.php; 
  fi
fi

