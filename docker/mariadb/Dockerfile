FROM docker.io/mariadb:10.4
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

