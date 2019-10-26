![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)

# GLPI Docker Container


## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)


## Install on docker container 

### Play

[![asciicast](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica.svg)](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica)


## docker-compose.yaml

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
    #
    networks: 
        glpi-frontend: 
        glpi-backend:
    #
    volumes:
        glpi-volume:
        mariadb-glpi-volume:


    docker-compose up -d




# Manual install

This script will install the GLPI on Linux Server CentOS 7 Minimal.  

## Silent

    curl -sSL 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' | bash


## Download 

    curl -sSL 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' -o install_glpi.sh 


## Configuration

Edit the script


    VERSION="9.4.4"                      # GLPI Version to install, default=9.4.4
    TIMEZONE=America/Fortaleza           # Timezone default=America/Fortaleza
    FQDN="glpi.eftech.com.br"            # Virtualhost default=glpi.eftech.com.br
    ADMINEMAIL="suporte@eftech.com.br"   # Admin e-mail virtualhost
    ORGANIZATION="EF-TECH"               # Organization name
    MYSQL_ROOT_PASSWORD=''               # MariaDB root password, default=empty
    DBUSER="glpi"                        # Database username, default=glpi
    DBHOST="localhost"                   # Database Host/IP, default=localhost
    DBNAME="glpi"                        # Database name, default=glpi
    # Create random password
    DBPASS="E`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" # 
    MYSQL_NEW_ROOT_PASSWORD="C`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" 
    
    

## Install

    sh install_glpi.sh

After instalation the script save the credentials and variables in ~/install_glpi.log for future maintenance. 

Example: 

    ====================================================
    ## VARIAVEIS
    
    VERSION=9.4.4
    TIMEZONE=America/Fortaleza
    FQDN=glpi.eftech.com.br
    ADMINEMAIL=suporte@eftech.com.br
    ORGANIZATION=EF-TECH
    MYSQL_ROOT_PASSWORD=
    DBUSER=glpi
    DBHOST=localhost
    DBNAME=glpi
    DBPASS=EmpNHclqyx8x_ufp6fl0GHDyVD-qSwA-i
    MYSQL_NEW_ROOT_PASSWORD=CHhXZvrX0EGDhtp08IRYuC1qswi-g2kW4
    
    
    MYSQL=mysql -u root -pCHhXZvrX0EGDhtp08IRYuC1qswi-g2kW4
    CURL=/usr/bin/curl
    
    ====================================================
    



## Courses e-Learning

https://www.fametreinamentos.com.br


## Support

https://www.fametec.com.br
    
contato@fametec.com.br

