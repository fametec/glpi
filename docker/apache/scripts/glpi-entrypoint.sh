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


ConfigDataBase

if [ ! -d /var/www/html/files/_config ]; then
  mkdir -p /var/www/html/files/_config
fi
if [ -e /var/www/html/config/glpicrypt.key ]; then
  if [ ! -L /var/www/html/config/glpicrypt.key ]; then
    mv /var/www/html/config/glpicrypt.key /var/www/html/files/_config/glpicrypt.key
	ln -s /var/www/html/files/_config/glpicrypt.key /var/www/html/config/glpicrypt.key
  fi
else
  ln -s /var/www/html/files/_config/glpicrypt.key /var/www/html/config/glpicrypt.key
fi
find /var/www/html -exec chown apache:apache {} \;

httpd -D FOREGROUND
