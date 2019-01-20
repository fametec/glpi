FROM docker.io/mariadb:latest
#
ENV MYSQL_ROOT_PASSWORD=qaz123
ENV MYSQL_DATABASE=glpi
ENV MYSQL_USER=glpi
ENV MYSQL_PASSWORD=glpi
#
VOLUME /var/lib/mysql
#
EXPOSE 3306
#
CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]
#
