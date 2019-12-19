FROM nginx

COPY fastcgi_params /etc/nginx/

COPY conf.d /etc/nginx/conf.d

COPY default.d /etc/nginx/default.d

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/conf.d/default.conf

VOLUME ["/usr/share/nginx/html"]

WORKDIR /usr/share/nginx/html

EXPOSE 80/tcp


