![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)


## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)


## Install on docker container 

### Play

[![asciicast](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica.svg)](https://asciinema.org/a/GUsmlWWh2rKKwV1pqNw3j5ica)


### Deploy MariaDB


    docker run -d --name mariadb-glpi \
    -e MYSQL_DATABASE=glpi \
    -e MYSQL_USER=glpi \
    -e MYSQL_PASSWORD=glpi \
    -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
    -p 3306:3306
    mariadb 


### Deploy GLPI


    docker run -d --name glpi \
    --link mariadb-glpi:mariadb-glpi \
    -e GLPI_LANG=pt_BR \
    -e MARIADB_HOST=mariadb-glpi \
    -e MARIADB_PORT=3306 \
    -e MARIADB_DATABASE=glpi \
    -e MARIADB_USER=glpi \
    -e MARIADB_PASSWORD=glpi \
    -e VERSION="9.4.4" \
    -e PLUGINS="all"
    -p 80:80 \
    -p 443:443 \
    fametec/glpi:9.4.4


### Deploy Cron to Schedule jobs


    docker run -d --name crond-glpi --link mariadb-glpi:mariadb --volume glpi:/var/www/html/glpi fametec/crond-glpi


## Install/Upgrade GLPI on docker container

To upgrade, just change VERSION, example: 

GLPI 9.3.2 to 9.4.4

    docker run -d --name glpi --link mariadb-glpi:mariadb --volume glpi-volume -e VERSION=9.4.4 fametec/glpi:9.4.4


Run configure.sh

    docker exec -it glpi /configure.sh


## docker-compose.yaml

    version: "3.5"
    services:
    #
    # MARIADB
    #
        mariadb-glpi: 
            image: docker.io/mariadb:latest
            restart: unless-stopped
    #        volumes: 
    #          - mariadb-glpi-volume:/var/lib/mysql:rw
            environment: 
              MYSQL_DATABASE: glpi
              MYSQL_USER: glpi 
              MYSQL_PASSWORD: glpi 
              MYSQL_RANDOM_ROOT_PASSWORD: 1 
    #        ports: 
    #          - 3307:3306
            networks: 
              - glpi-backend
    #
    # GLPI
    #
        glpi: 
            image: fametec/glpi:latest
            restart: unless-stopped
     #       volumes: 
     #         - glpi-volume:/var/www/html:rw
            environment: 
              GLPI_LANG: pt_BR
              MARIADB_HOST: mariadb-glpi
              MARIADB_PORT: 3306
              MARIADB_DATABASE: glpi
              MARIADB_USER: glpi
              MARIADB_PASSWORD: glpi
              VERSION: "9.4.4"
              PLUGINS: "all"
            depends_on: 
              - mariadb-glpi
            ports: 
              - 30080:80
              - 30443:443
            networks: 
              - glpi-frontend
              - glpi-backend
    #
    # CRON
    #
        crond: 
            image: fametec/crond-glpi:latest
            restart: unless-stopped
            depends_on: 
              - glpi
              - mariadb-glpi
            environment: 
              MARIADB_HOST: mariadb-glpi
              MARIADB_PORT: 3306
              MARIADB_DATABASE: glpi
              MARIADB_USER: glpi
              MARIADB_PASSWORD: glpi
    #        volumes: 
    #          - glpi-volume:/var/www/html:rw
            networks: 
              - glpi-backend
    #
    # VOLUMES
    #
    #volumes: 
    #  glpi-volume:
    #  mariadb-glpi-volume: 
    #
    # NETWORKS
    #
    networks: 
      glpi-frontend: 
      glpi-backend:



# Plugins available

 - fields
 - costs
 - datainjection
 - formcreator
 - tag
 - genericobject
 - Mod
 - pdf
 - ocsinventoryng
 - tasklists
 - telegrambot
 - fusioninventory


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

