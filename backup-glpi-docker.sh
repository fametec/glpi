#!/bin/sh

#Debug
# set -xv

# Install on /etc/cron.daily/backup-glpi-docker.sh
# chmod +x /etc/cron.daily/backup-glpi-docker.sh
# 

MYSQL_HOST=127.0.0.1
MYSQL_PORT=3309
MYSQL_DATABASE=glpi
MYSQL_USER=glpi
MYSQL_PASSWORD=glpi

BACKUP_DESTINATION=/backup/glpi


NOW=`date +%Y-%m-%d-%H-%M`

TEMPDIR=`mktemp -d`

if [ ! -d $BACKUP_DESTINATION ]; then
  mkdir -p $BACKUP_DESTINATION
fi


/bin/docker cp glpi_glpi_1:/var/www/html/glpi ${TEMPDIR}/

EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t BACKUP_FILES_GLPI "ALERT exited abnormally with $EXITVALUE"
    exit $EXITVALUE
fi


/bin/mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u glpi -p${MYSQL_PASSWORD} --single-transaction --routines --databases $MYSQL_DATABASE | gzip > ${TEMPDIR}/glpi/files/_dumps/glpi-backup-${NOW}.sql.gz

EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t BACKUP_DUMP_GLPI "ALERT exited abnormally with $EXITVALUE"
    exit $EXITVALUE
fi


/bin/tar -zcf $BACKUP_DESTINATION/glpi-entire-${NOW}.tar.gz ${TEMPDIR}

EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t TAR_BACKUP_GLPI "ALERT exited abnormally with $EXITVALUE"
    exit $EXITVALUE
fi




/bin/find $BACKUP_DESTINATION -mtime +7 -delete

EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t CLEAR_BACKUP_GLPI "ALERT exited abnormally with $EXITVALUE"
    exit $EXITVALUE
fi


rm -rf ${TEMPDIR}

exit 0
