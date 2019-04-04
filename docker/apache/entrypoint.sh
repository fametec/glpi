#!/bin/bash
#
set -x
# 

functionSetSubVersion () {
    local _version=$1
    local _index=$2
    local _out=`echo ${_version} | cut -d . -f${_index}`
    return $_out
}

functionSetPermission () {
    chown -Rf apache:apache /var/www/html/glpi
}

functionGetCurrentVersion () {
    echo "{ `curl -s http://localhost/glpi/ajax/telemetry.php | grep -v code` }" | jq -r '.glpi.version'
}

functionInstall () {
    echo "Download and install GLPI $VERSION ..."
    
    if [ -e /glpi-$VERSION.tgz ]; then
      tar -zxf /glpi-$VERSION.tgz -C /var/www/html/
    else
      curl -sSL https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz | tar -zxf - -C /var/www/html/
    fi
    functionSetPermission	
}

functionUpgrade () {
    
    functionSetSubVersion $VERSION 2

    if [ $? -ge 4 ]; then
      echo "Upgrade to $VERSION using bin/console..."
      /usr/bin/php /var/www/html/glpi/bin/console glpi:database:update --no-interaction
      /usr/bin/php /var/www/html/glpi/bin/console glpi:migration:myisam_to_innod --no-interaction
    else
      echo "Upgrade to $VERSION using cliupdate script..."
      /usr/bin/php /var/www/html/glpi/scripts/cliupdate.php
      /usr/bin/php /var/www/html/glpi/scripts/innodb_migration.php
    fi
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

    functionSetSubVersion $VERSION 2

    if [ $? -ge 4 ]; then
      echo "Deploy DB using bin/console. Please wait..."
      /usr/bin/php /var/www/html/glpi/bin/console glpi:database:install \
	--no-interaction \
	--db-host=${MARIADB_HOST} \
	--db-port=${MARIADB_PORT} \
	--db-name=$MARIADB_DATABASE \
	--db-user=$MARIADB_USER \
	--db-password=$MARIADB_PASSWORD \
	--default-language=$GLPI_LANG
    else 
      echo "Deploy DB using cliinstall.php. Please wait..." 
      /usr/bin/php /var/www/html/glpi/scripts/cliinstall.php \
        --host=${MARIADB_HOST} \
        --hostport=${MARIADB_PORT} \
        --db=$MARIADB_DATABASE \
        --user=$MARIADB_USER \
        --pass=$MARIADB_PASSWORD \
        --lang=$GLPI_LANG 
   fi
}

if [ ! -d /var/www/html/glpi/ ]; then
    echo "Directory not found, go to install..." 
    functionInstall 
fi

if [ -e /var/www/html/glpi/config/config_db.php ]; then
    echo "DB Already installed. " 
    functionConfigDataBase
else
    sleep 5
    functionDeployDataBase
    functionConfigDataBase
fi
#
functionSetPermission
#
httpd -D FOREGROUND &


sleep 5

CURRENTVERSION=`functionGetCurrentVersion`

if [ "$CURRENTVERSION" == "$VERSION" ] || [ "$CURRENTVERSION" == "" ]; then
  echo "Version $CURRENTVERSION = $VERSION"
else
  echo "Upgrading from $CURRENTVERSION to $VERSION ..."
  functionInstall
  functionConfigDataBase
  functionUpgrade
#  functionRemoveInstall
fi

functionRemoveInstall

echo 
echo "GLPI UP!!!"
echo

while true; do sleep 1000; done
