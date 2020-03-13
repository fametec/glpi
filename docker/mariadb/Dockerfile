FROM docker.io/mariadb:latest
#
ENV MYSQL_RANDOM_ROOT_PASSWORD yes
ENV MYSQL_DATABASE glpi
ENV MYSQL_USER glpi
ENV MYSQL_PASSWORD glpi
#
VOLUME /var/lib/mysql
#
EXPOSE 3306
#
COPY src/*.sql /docker-entrypoint-initdb.d/
#
CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]
#
