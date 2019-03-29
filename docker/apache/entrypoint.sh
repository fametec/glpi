#!/bin/bash
#
set -x
# 
if [ -d /var/www/html/glpi/ ]; then
  echo -n "Directory found, not to do!"
else
  echo "Directory not found, creating..." 
  curl -sSL https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz | tar -zxf - -C /var/www/html/
  #mv /tmp/glpi /var/www/html/
  chown -Rf apache:apache /var/www/html/glpi
fi
#
if [ -e /var/www/html/glpi/config/config_db.php ]; then
  echo "DB Already installed (see --force option)" 
  {
    echo "<?php"; \
    echo "class DB extends DBmysql {"; \
    echo "   public \$dbhost     = \"${MARIADB_HOST}\";"; \
    echo "   public \$dbport     = \"${MARIADB_PORT}\";"; \
    echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
    echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
    echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
    echo "}"; \
    echo ; 
  } > /var/www/html/glpi/config/config_db.php
  rm -rf /var/www/html/glpi/install/install.php;
#
else
  echo "Deploy DB with cliinstall.php. Please wait..." 
  /usr/bin/php /var/www/html/glpi/scripts/cliinstall.php \
	--host=$MARIADB_HOST \
	--db=${MARIADB_DATABASE}:${MARIADB_PORT} \
	--user=$MARIADB_USER \
	--pass=$MARIADB_PASSWORD \
	--lang=$GLPI_LANG 
  if [ $? -eq 0 ]; then
   rm -rf /var/www/html/glpi/install/install.php; 
  fi
fi
#
chown -Rf apache:apache /var/www/html/glpi 
#
httpd -D FOREGROUND
