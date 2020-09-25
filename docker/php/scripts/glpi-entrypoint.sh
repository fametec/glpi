#!/bin/sh

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
      } > /usr/share/nginx/html/glpi/config/config_db.php

}

ConfigOwner () {

  chown -R www-data:www-data /usr/share/nginx/html/glpi
  chmod g+w /usr/share/nginx/html/glpi/files
  chmod g+w /usr/share/nginx/html/glpi/plugins

}

ConfigDataBase
ConfigOwner

php-fpm