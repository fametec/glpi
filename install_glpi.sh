#!/bin/bash

# Debug

set -xv

## VARIAVEIS

VERSION="9.2.2"
TIMEZONE=America/Fortaleza
FQDN="glpi.eftech.com.br"
ADMINEMAIL="suporte@eftech.com.br"
ORGANIZATION="EF-TECH"
MYSQL_ROOT_PASSWORD=''
DBUSER="glpi"
DBHOST="localhost"
DBNAME="glpi"
#DBPASS="E`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`"
DBPASS="qaz123"
MYSQL_NEW_ROOT_PASSWORD="qaz123"
#MYSQL_NEW_ROOT_PASSWORD="C`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`"


MYSQL="mysql -u root -p${MYSQL_NEW_ROOT_PASSWORD}"
CURL=`which curl`


## SELINUX

sed -i s/enforcing/permissive/g /etc/selinux/config
setenforce 0

#    chcon -R -t httpd_sys_rw_content_t /var/www/html/glpi/
#    setsebool -P httpd_can_network_connect 1
#    setsebool -P httpd_can_network_connect_db 1
#    setsebool -P httpd_can_sendmail 1
#    setenforce 1



## INSTALL MARIADB-SERVER

yum -y install mariadb-server expect epel-release


## Restart do mysql

systemctl enable mariadb
systemctl restart mariadb


## Configuração de segurança do banco

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Change the root password?\"
send \"y\r\"
expect \"New password:\"
send \"$MYSQL_NEW_ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_NEW_ROOT_PASSWORD\r\" 
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"


## DATABASE

$MYSQL -e "create database $DBNAME character set utf8;"
$MYSQL -e "create user $DBUSER@localhost identified by '"$DBPASS"';"
$MYSQL -e "grant all privileges on $DBNAME.* to $DBUSER@localhost;"


## APACHE

yum install -y httpd mod_ssl

systemctl enable httpd 

systemctl start httpd


## PHP 7

cd ~ 

curl 'https://setup.ius.io/' -o setup-ius.sh 

bash setup-ius.sh  

yum -y remove php-cli mod_php php-common -y 

yum -y install mod_php70u php70u-cli php70u-mysqlnd 

yum -y install php70u-json php70u-mbstring php70u-mysqli php70u-session php70u-gd php70u-curl php70u-domxml php70u-imap php70u-ldap php70u-openssl php70u-opcache php70u-apcu php70u-xmlrpc openssl 


cat <<EOF > /etc/php.d/99-glpi.ini
memory_limit = 64M ;
file_uploads = on ;
max_execution_time = 600 ;
register_globals = off ; 
magic_quotes_sybase = off ;
session.auto_start = off ;
session.use_trans_sid = 0 ; 
EOF


cat <<EOF > /etc/php.d/timezone.ini
[Date]
date.timezone = $TIMEZONE ; 
EOF


## DOWNLOAD AND INSTALL GLPI

yum -y install wget

if [ ! -e packages/$VERSION/glpi-$VERSION.tgz ]
then

  wget -c https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz -O packages/glpi-$VERSION.tgz

fi

tar -zxvf package/glpi-$VERSION.tgz -C /var/www/html/

chown -R apache:apache /var/www/html/glpi


cat <<EOF > /etc/httpd/conf.d/glpi.conf
    <Directory /var/www/html/glpi/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
EOF


systemctl restart httpd


