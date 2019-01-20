#!/bin/bash
#
# 
#if [ ! -d /var/www/html/glpi ]; then 
#tar -zxf /glpi-9.3.2.tgz -C /var/www/html/ 
# chown -Rf apache:apache /var/www/html/glpi 
#fi
# /installdb.sh
#
httpd -D FOREGROUND
status=$?
if [ $status -ne 0 ]; then
   echo "Failed to start httpd_process: $status"
  exit $status
fi
#
while sleep 60; do
  ps aux |grep httpd |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

