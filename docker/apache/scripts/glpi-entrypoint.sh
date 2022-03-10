#!/bin/bash

ConfigDataBase () {

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
      } > /var/www/html/config/config_db.php

}


VerifyDir () {

  DIR="/var/www/html/files/_cron
  /var/www/html/files/_dumps
  /var/www/html/files/_graphs
  /var/www/html/files/_log
  /var/www/html/files/_lock
  /var/www/html/files/_pictures
  /var/www/html/files/_plugins
  /var/www/html/files/_rss
  /var/www/html/files/_tmp
  /var/www/html/files/_uploads
  /var/www/html/files/_cache
  /var/www/html/files/_sessions
  /var/www/html/files/_locales"

  for i in $DIR
  do 
    if [ ! -d $i ]
    then
      echo -n "Creating $i dir... " 
      mkdir -p $i
      echo "done"
    fi
  done
}

VerifyKey () {

  if [ ! -e /var/www/html/config/glpicrypt.key ]
  then
    php -c /etc/php.ini bin/console glpi:security:change_key --no-interaction
  fi

}

SetPermissions () {
  echo -n "Setting chown in files and plugins... "
  chown -R apache:apache /var/www/html/files
  chown -R apache:apache /var/www/html/plugins
  echo "done"

}

ConfigDataBase

VerifyDir

VerifyKey

SetPermissions

httpd -D FOREGROUND

