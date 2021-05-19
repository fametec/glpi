![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)

# GLPI Docker Container

## Demo

https://www.katacoda.com/eduardofraga/scenarios/glpi-playground 


## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.

https://github.com/glpi-project/glpi


## For Courses e-Learning

https://www.fametreinamentos.com.br


## For Support

https://www.fametec.com.br
    
contato@fametec.com.br


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)


## Topology


![Topology](https://raw.githubusercontent.com/fametec/glpi/master/topologia-docker-compose-glpi.png)


## Install on docker container 

### Play

[![asciicast](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica.svg)](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica)


### Deploy MariaDB


    docker run -d --name mariadb-glpi \
    -e MYSQL_DATABASE=glpi \
    -e MYSQL_USER=glpi \
    -e MYSQL_PASSWORD=glpi \
    -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
    -p 3306:3306 \
    fametec/glpi:mariadb


### Deploy GLPI


    docker run -d --name glpi \
    --link mariadb-glpi:mariadb-glpi \
    -e GLPI_LANG=pt_BR \
    -e MARIADB_HOST=mariadb-glpi \
    -e MARIADB_PORT=3306 \
    -e MARIADB_DATABASE=glpi \
    -e MARIADB_USER=glpi \
    -e MARIADB_PASSWORD=glpi \
    -e VERSION="9.5.5" \
    -e PLUGINS="all" \
    -p 80:80 \
    -p 443:443 \
    fametec/glpi:latest


### Deploy Cron to Schedule jobs


    docker run -d --name crond-glpi --link mariadb-glpi:mariadb --volume glpi:/var/www/html/glpi fametec/glpi:crond


# Docker Compose

### docker-compose.yaml



    version: "3.5"
    services:
        mariadb-glpi: 
            image: fametec/glpi:mariadb
            restart: unless-stopped
            volumes: 
              - mariadb-glpi-volume:/var/lib/mysql:rw
            environment: 
              MYSQL_DATABASE: glpi
              MYSQL_USER: glpi-user 
              MYSQL_PASSWORD: glpi-pass 
              MYSQL_RANDOM_ROOT_PASSWORD: 1 
            ports: 
              - 3306:3306
            networks: 
              - glpi-backend
        glpi: 
            image: fametec/glpi:latest
            restart: unless-stopped
            volumes: 
              - glpi-volume-files:/var/www/html/files:rw
              - glpi-volume-plugins:/var/www/html/plugins:rw
            environment: 
              GLPI_LANG: pt_BR
              MARIADB_HOST: mariadb-glpi
              MARIADB_PORT: 3306
              MARIADB_DATABASE: glpi
              MARIADB_USER: glpi-user
              MARIADB_PASSWORD: glpi-pass
              VERSION: "9.5.5"
              PLUGINS: "all"
            depends_on: 
              - mariadb-glpi
              - php-fpm
            ports: 
              - 30080:80
            networks: 
              - glpi-frontend
              - glpi-backend
    #
    # CRON
    #
        crond: 
            image: fametec/glpi:crond
            restart: unless-stopped
            volumes:
              - glpi-volume:/usr/share/nginx/html/glpi:rw
            depends_on:
              - mariadb-glpi
            environment: 
              MARIADB_HOST: mariadb-glpi
              MARIADB_PORT: 3306
              MARIADB_DATABASE: glpi
              MARIADB_USER: glpi-user
              MARIADB_PASSWORD: glpi-pass
            volumes: 
              - glpi-volume-files:/var/www/html/files:rw
              - glpi-volume-plugins:/var/www/html/plugins:rw
            networks: 
              - glpi-backend
    #
    # VOLUMES
    #
    volumes: 
      glpi-volume-files:
      glpi-volume-plugins:
      mariadb-glpi-volume: 
    #
    # NETWORKS
    #
    networks: 
      glpi-frontend: 
      glpi-backend:



# Manual install

This script will install the GLPI on Linux Server CentOS 7.6  Minimal.  

## Play

[![asciicast](https://asciinema.org/a/Rb61UJXZh7mbMQuIoVoiURKQg.svg)](https://asciinema.org/a/Rb61UJXZh7mbMQuIoVoiURKQg)


## Silent

    ```curl -sSL 'https://raw.githubusercontent.com/fametec/glpi/master/install_glpi.sh' | bash```


## Download 


    ```curl -sSL 'https://raw.githubusercontent.com/fametec/glpi/master/install_glpi.sh' -o install_glpi.sh ```


## Configuration

Edit the script


    VERSION="9.5.5"                      # GLPI Version to install
    TIMEZONE=America/Fortaleza           # Timezone default=Etc/UTC
    FQDN="glpi.fametec.com.br"           # Virtualhost default=glpi.fametec.com.br
    ADMINEMAIL="suporte@fametec.com.br"  # Admin e-mail 
    ORGANIZATION="FAMETec"               # Organization name
    MYSQL_ROOT_PASSWORD=''               # MariaDB root password, default=empty
    DBUSER="glpi"                        # Database username, default=glpi
    DBHOST="localhost"                   # Database Host/IP, default=localhost
    DBNAME="glpi"                        # Database name, default=glpi
    DBPASS="E`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" # 
    MYSQL_NEW_ROOT_PASSWORD="C`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" 
    
    



After instalation the script save the credentials and variables in ''install_glpi.log'' for future maintenance. 


    ====================================================
    ## VARIAVEIS
    
    VERSION=9.5.5
    TIMEZONE=America/Fortaleza
    FQDN=glpi.fametec.com.br
    ADMINEMAIL=suporte@fametec.com.br
    ORGANIZATION=FAMETec
    MYSQL_ROOT_PASSWORD=
    DBUSER=glpi
    DBHOST=localhost
    DBNAME=glpi
    DBPASS=EmpNHclqyx8x_ufp6fl0GHDyVD-qSwA-i
    MYSQL_NEW_ROOT_PASSWORD=CHhXZvrX0EGDhtp08IRYuC1qswi-g2kW4
    
    
    MYSQL=mysql -u root -pCHhXZvrX0EGDhtp08IRYuC1qswi-g2kW4
    CURL=/usr/bin/curl
    
    ====================================================
    


