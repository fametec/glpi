#!/bin/bash
#
# 
if [ -d /var/www/html/glpi ]; then
  echo "Directory found, not to do..."
  rm -rf /tmp/glpi
else
  echo "Directory not found, creating..." 
  curl -sSL https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz | tar -zxvf - -C /var/www/html/
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
    echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
    echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
    echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
    echo "}"; \
    echo ; 
  } > /var/www/html/glpi/config/config_db.php
#
else
  echo "Deploy DB with cliinstall.php. This procedure delay 10 minutes. Please wait..." 
  cd /var/www/html/glpi/scripts && php cliinstall.php \
	--host=$MARIADB_HOST \
	--db=$MARIADB_DATABASE \
	--user=$MARIADB_USER \
	--pass=$MARIADB_PASSWORD \
	--lang=$GLPI_LANG
  if [ $? -eq 0 ]; then
   rm -rf /var/www/html/glpi/install/install.php; 
  fi
fi

# mv /tmp/config_db.php /var/www/html/glpi/config/
chown -Rf apache:apache /var/www/html/glpi 

httpd -D FOREGROUND
