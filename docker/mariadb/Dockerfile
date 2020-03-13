FROM docker.io/mariadb:latest

ENV MYSQL_RANDOM_ROOT_PASSWORD yes
ENV MYSQL_DATABASE glpi
ENV MYSQL_USER glpi
ENV MYSQL_PASSWORD glpi
#
VOLUME /var/lib/mysql
#
EXPOSE 3306

<<<<<<< HEAD
COPY src/*.sql /docker-entrypoint-initdb.d/
=======
COPY src/*.sql /
>>>>>>> 25daf5836dabaddb4c2a369494225c6045fe9f98
#
CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]
#
