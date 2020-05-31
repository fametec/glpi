FROM fametec/glpi:9.4.6-php-fpm as PHP

FROM nginx:alpine

MAINTAINER eduardo@fametec.com.br

ENV VERSION 9.4.6

WORKDIR /usr/share/nginx/html

RUN rm -f /etc/nginx/conf.d/default.conf

COPY fastcgi_params /etc/nginx/

COPY conf.d /etc/nginx/conf.d

COPY default.d /etc/nginx/default.d

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=PHP --chown=nginx:nginx /usr/share/nginx/html/glpi /usr/share/nginx/html/glpi

VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins" ]

EXPOSE 80/tcp
