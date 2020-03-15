#!/bin/sh

#Debug
# set -xv
#MARIADB_DATABASE="glpi"
#MARIADB_HOST="mariadb-glpi"
#MARIADB_PASSWORD="glpi"
#MARIADB_PORT="3306"
#MARIADB_USER="glpi"

NOW=`date +%Y-%m-%d-%H-%M`

if [ -z $MARIADB_DATABASE ]; then 
  MARIADB_DATABASE="glpi"
fi

if [ -z $MARIADB_HOST ]; then
  MARIADB_HOST="mariadb-glpi"
fi

if [ -z $MARIADB_PASSWORD ]; then
  MARIADB_PASSWORD="glpi"
fi

if [ -z $MARIADB_PORT ]; then
  MARIADB_PORT="3306"
fi

if [ -z $MARIADB_USER ]; then
  MARIADB_USER="glpi"
fi

/bin/mysqldump -h $MARIADB_HOST -P $MARIADB_PORT -u $MARIADB_USER -p$MARIADB_PASSWORD --single-transaction --databases $MARIADB_DATABASE | /usr/bin/gzip > /var/www/html/files/_dumps/glpi-backup-${NOW}.sql.gz

if [ $? -eq 0 ]; then

  chown -R apache:apache /var/www/html/files/_dumps/glpi-backup-${NOW}.sql.gz

  ls -lh /var/www/html/files/_dumps/glpi-backup-${NOW}.sql.gz

fi

/bin/find /var/www/html/files/_dumps/ -mtime +30 -delete

