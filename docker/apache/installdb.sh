#!/bin/bash
if [ -e /var/www/html/glpi/config/config_db.php ]; then
  echo "Already installed (see --force option)" 
else
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

