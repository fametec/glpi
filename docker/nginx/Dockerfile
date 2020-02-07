FROM nginx

MAINTAINER eduardo@fametec.com.br

ENV VERSION 9.4.5

RUN rm -f /etc/nginx/conf.d/default.conf

COPY fastcgi_params /etc/nginx/

COPY conf.d /etc/nginx/conf.d

COPY default.d /etc/nginx/default.d

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

ADD https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz /usr/share/nginx/html/

RUN tar -zxf glpi-$VERSION.tgz -C /usr/share/nginx/html/ \
	&& chown -R www-data:www-data /usr/share/nginx/html/glpi \
	&& rm -rf glpi-$VERSION.tgz

VOLUME ["/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins", "/usr/share/nginx/html/glpi/config"]

EXPOSE 80/tcp


