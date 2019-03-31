#!/bin/bash
#
set -x
# 

functionSetPermission () {
    chown -Rf apache:apache /var/www/html/glpi
}

functionGetCurrentVersion () {
    echo "{ `curl -s http://localhost/glpi/ajax/telemetry.php | grep -v code` }" | jq -r '.glpi.version'
}

functionInstall () {
    curl -sSL https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz | tar -zxf - -C /var/www/html/
    functionSetPermission	
}

functionUpgrade () {
   cd /var/www/html/glpi/scripts/
   /usr/bin/php cliupdate.php
   /usr/bin/php innodb_migration.php 
}


functionRemoveInstall () {
    rm -rf /var/www/html/glpi/install/install.php;
}

functionConfigDataBase () {
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
}

functionDeployDataBase () {
      echo "Deploy DB with cliinstall.php. Please wait..." 
      sleep 5
      /usr/bin/php /var/www/html/glpi/scripts/cliinstall.php \
        --host=${MARIADB_HOST} \
        --hostport=${MARIADB_PORT} \
        --db=$MARIADB_DATABASE \
        --user=$MARIADB_USER \
        --pass=$MARIADB_PASSWORD \
        --lang=$GLPI_LANG 
      if [ $? -eq 0 ]; then
	functionRemoveInstall
      fi
}

if [ -d /var/www/html/glpi/ ]; then
    echo -n "Directory found, not to do!"
else
    echo "Directory not found, creating..." 
    functionInstall 
fi
#
if [ -e /var/www/html/glpi/config/config_db.php ]; then
    echo "DB Already installed (see --force option)" 
    functionConfigDataBase
else
    echo "Deploy DB with cliinstall.php. Please wait..." 
    sleep 5
    functionDeployDataBase
    functionConfigDataBase
    if [ $? -eq 0 ]; then
      functionRemoveInstall 
    fi
fi
#
functionSetPermission
#
httpd -D FOREGROUND &


sleep 5

CURRENTVERSION=`functionGetCurrentVersion`

if [ ! "$CURRENTVERSION" == "$VERSION" ]; then
  echo "Upgrading from $CURRENTVERSION to $VERSION ..."
  functionInstall
  functionConfigDataBase
  functionUpgrade
else
  functionRemoveInstall
fi



while true; do sleep 1000; done
