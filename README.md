# GLPI 

This project have a objective to simplify the GLPI instalation with two methods: 
- Deploy a docker container or Kubernetes
- Manual install on Linux Server CentOS 7 Minimal 


# Docker install 

The docker instalation is split with three containers: 

- fametec/mariadb 
- fametec/glpi
- fametec/crond-glpi

## Deploying

### Deploy MariaDB

Create a volume to persistent data (optional) 

    docker volume create mariadb-glpi-volume

Run a Container

    docker run -d --name mariadb-glpi -v mariadb-glpi-volume:/var/lib/mysql fametec/mariadb-glpi


### Deploy GLPI

Create a volume to persistent data (optional)

    docker volume create glpi-volume

Run basic

    docker run -d --name glpi --link mariadb-glpi:mariadb --volume glpi-volume fametec/glpi

Run advanced

    docker run -d \
    --name glpi \
    --link mariadb-glpi:mariadb-glpi \
    --volume glpi-volume:/var/www/html \
    -e GLPI_LANG=pt_BR \
    -e MARIADB_HOST=mariadb-glpi \
    -e MARIADB_DATABASE=glpi \
    -e MARIADB_USER=glpi \
    -e MARIADB_PASSWORD=glpi \
    -e VERSION=9.4.0 \
    fametec/glpi


### Deploy Cron to Schedule jobs

Required MariaDB and GLPI

    docker run -d --name crond-glpi --link mariadb-glpi:mariadb --volume glpi-volume:/var/www/html/glpi fametec/crond-glpi


## Upgrade GLPI on docker container

To upgrade, just change VERSION, example: 

GLPI 9.3.2 to 9.4.0

    docker run -d --name glpi --link mariadb-glpi:mariadb --volume glpi-volume -e VERSION=9.4.0 fametec/glpi



# Manual install

This script will install the GLPI on Linux Server CentOS 7 Minimal.  

## Silent

    curl -sSL 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' | bash


## Download 

    curl -sSL 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' -o install_glpi.sh 


## Configuration

Edit the script after install.


    VERSION="9.3.2"                      # GLPI Version to install, default=9.3.2
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
    
    VERSION=9.3.2
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

https://www.fameconsultoria.com.br

https://www.fametec.com.br
    
contato@fametec.com.br


