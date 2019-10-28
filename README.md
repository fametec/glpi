![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)

# GLPI Docker Container


## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)


## Install on docker container 

[![asciicast](https://asciinema.org/a/277490.svg)](https://asciinema.org/a/277490)


### Download and Install


    curl -sSL https://raw.githubusercontent.com/fametec/glpi/9.4.4-nginx/docker/docker-compose.yml -o docker-compose.yml


### docker-compose.yaml

    version: "3.5"
    services:
        mariadb-glpi: 
            image: docker.io/mariadb:latest
            restart: unless-stopped
            volumes:
              - mariadb-glpi-volume:/var/lib/mysql:rw
            environment: 
              MYSQL_DATABASE: glpi
              MYSQL_USER: glpi 
              MYSQL_PASSWORD: glpi 
              MYSQL_RANDOM_ROOT_PASSWORD: 1 
            networks: 
              - glpi-backend
        glpi: 
            image: fametec/glpi-nginx:latest
            restart: unless-stopped
            environment: 
              GLPI_LANG: pt_BR
              MARIADB_HOST: mariadb-glpi
              MARIADB_PORT: 3306
              MARIADB_DATABASE: glpi
              MARIADB_USER: glpi
              MARIADB_PASSWORD: glpi
              VERSION: "9.4.4"
              PLUGINS: "all"
            volumes:
              - glpi-volume:/usr/share/nginx/html/glpi:rw
            depends_on: 
              - mariadb-glpi
              - php-fpm
            ports: 
              - 30080:80
            networks: 
              - glpi-frontend
              - glpi-backend
        php-fpm: 
            image: fametec/glpi-php-fpm:latest
            restart: unless-stopped
            volumes:
              - glpi-volume:/usr/share/nginx/html/glpi:rw
            depends_on:
              - mariadb-glpi
            ports:
              - 9000:9000
            networks:
              - glpi-backend
        cron:
            image: fametec/glpi-cron-php-fpm
            restart: unless-stopped
            volumes:
              - glpi-volume:/usr/share/nginx/html/glpi:rw
            depends_on:
              - mariadb-glpi
            networks:
              - glpi-backend
    #
    networks: 
        glpi-frontend: 
        glpi-backend:
    #
    volumes:
        glpi-volume:
        mariadb-glpi-volume:





### Deploy with docker-compose


    docker-compose up



## Courses e-Learning

https://www.fametreinamentos.com.br


## Support

https://www.fametec.com.br
    
contato@fametec.com.br

