#!/bin/bash

###############################################################################

# Debug

# set -xv

## VARIABLES

LOGS="install_glpi.log"
GLPI_LANG="en_US"
# GLPI_LANG="pt_BR"
VERSION="9.5.5"
TIMEZONE=Etc/UTC
# TIMEZONE=America/Fortaleza
FQDN="glpi.fametec.com.br"
ADMINEMAIL="suporte@fametec.com.br"
ORGANIZATION="FAMETec"
MYSQL_ROOT_PASSWORD=''
DBUSER="glpi"
DBHOST="localhost"
DBPORT=3306
DBNAME="glpi"
DBPASS="E`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`"
MYSQL_NEW_ROOT_PASSWORD="C`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`"
# DBPASS="qaz123"
# MYSQL_NEW_ROOT_PASSWORD="qaz123"


MYSQL="mysql -u root -p${MYSQL_NEW_ROOT_PASSWORD}"
CURL=`which curl`


Log () {

cat <<EOF > $LOGS

====================================================
## VARIAVEIS

VERSION=$VERSION
TIMEZONE=$TIMEZONE
FQDN=$FQDN
ADMINEMAIL=$ADMINEMAIL
ORGANIZATION=$ORGANIZATION
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
DBUSER=$DBUSER
DBHOST=$DBHOST
DBPORT=$DBPORT
DBNAME=$DBNAME
DBPASS=$DBPASS
MYSQL_NEW_ROOT_PASSWORD=$MYSQL_NEW_ROOT_PASSWORD


MYSQL=$MYSQL
CURL=$CURL

====================================================



EOF


}


EnableFirewall() {

  echo "Setting firewall rules..." 

  systemctl enable --now firewalld 

  firewall-cmd --zone=public --add-service=http --permanent 

  firewall-cmd --zone=public --add-service=https --permanent 

} 


DisableFirewall () {

  systemctl disable --now firewalld 
 
}

InstallRepo () {

  echo "Installing Yum Repo..."

  yum -y install expect\
  	epel-release \
	yum-utils

  yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

  yum-config-manager --enable remi-php73

  cat <<EOF > /etc/yum.repos.d/MariaDB.repo

[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF


}

InstallDataBase () {
  
  echo "Remove old database..."

  yum -y remove \
	mariadb-server \
	mariadb \
	mariadb-config \
	mariadb-libs \
	mariadb-common 

  echo "Install MariaDB 10.0u..."
  
  yum -y install \
        MariaDB-server \
	MariaDB-client

  echo "Enable service..." 

  systemctl enable --now  mariadb 

}

SetDataBaseSecure () { 

  echo "Running mysql_secure_installation..."

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Set the root password?\"
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

} 


CreateDataBase () {

  echo "Creating database $DBNAME..."

  $MYSQL -e "create database $DBNAME character set utf8;"

  $MYSQL -e "create user $DBUSER@localhost identified by '"$DBPASS"';"

  $MYSQL -e "grant all privileges on $DBNAME.* to $DBUSER@localhost;"

}

InstallApache () {

  echo "Installing Apache..."

  yum -y install \
	httpd \
	mod_ssl

}


InstallPhp () {

  echo "Remove old PHP..."

  yum -y remove \
	php-cli \
	mod_php \
	php-common 

  echo "Install php73..."

  yum -y install \
	mod_php \
	php-cli \
	php-mysqlnd 

  yum -y install \
	php-pear-CAS \
	wget \
	php-json \
	php-mbstring \
	php-mysqli \
	php-session \
	php-gd \
	php-curl \
	php-domxml \
	php-imap \
	php-ldap \
	php-openssl \
	php-opcache \
	php-apcu \
	php-xmlrpc \
	php-intl \
	php-zip \
	php-sodium
	php-ZendFramework-Cache-Backend-Apc \
	jq \
	openssl 
  
}


SetPhpIni () {

  echo "Setting 99-glpi.ini..."

  cat <<EOF > /etc/php.d/99-glpi.ini
memory_limit = 64M ;
file_uploads = on ;
max_execution_time = 600 ;
register_globals = off ; 
magic_quotes_sybase = off ;
session.auto_start = off ;
session.use_trans_sid = 0 ; 
EOF


  cat <<EOF > /etc/php.d/99-timezone.ini
[Date]
date.timezone = $TIMEZONE ; 
EOF


  cat <<EOF > /etc/php.d/99-apcu.ini
apc.enable_cli = 1 ; 
EOF


} 

Install () {

    echo "Download and install GLPI $VERSION ..."
    curl -sSL https://github.com/glpi-project/glpi/releases/download/$VERSION/glpi-$VERSION.tgz | tar -zxf - -C /var/www/html/

}


SetPermission () {
    chown -Rf apache:apache /var/www/html/glpi
}


SetHttpConf () {

cat <<EOF > /etc/httpd/conf.d/glpi.conf
<VirtualHost *:80>
    ServerName ${FQDN}
    DocumentRoot /var/www/html/glpi
    <Directory /var/www/html/glpi/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

}


DisableSELinux () {

  sed -i s/enforcing/permissive/g /etc/selinux/config
  
  setenforce 0

}


EnableSELinux () {

    chcon -R -t httpd_sys_rw_content_t /var/www/html/glpi/
    setsebool -P httpd_can_network_connect 1
    setsebool -P httpd_can_network_connect_db 1
    setsebool -P httpd_can_sendmail 1
    setenforce 1

} 

StartHttpd () {

  echo "Start HTTPD..." 

  systemctl enable --now httpd

} 


DeployDataBase () {

    local SUBVERSION=`echo $VERSION | cut -d . -f 2`

    if [ $SUBVERSION -ge 4 ]; then
      echo "Deploy DB using bin/console. Please wait..."
      /usr/bin/php /var/www/html/glpi/bin/console glpi:database:install \
	--no-interaction \
	--db-host=${DBHOST} \
	--db-port=${DBPORT} \
	--db-name=${DBNAME} \
	--db-user=${DBUSER} \
	--db-password=${DBPASS} \
	--default-language=${GLPI_LANG}
    else 
      echo "Deploy DB using cliinstall.php. Please wait..." 
      /usr/bin/php /var/www/html/glpi/scripts/cliinstall.php \
        --host=${DBHOST} \
        --hostport=${DBPORT} \
        --db=$DBNAME \
        --user=$DBUSER \
        --pass=$DBPASS \
        --lang=$GLPI_LANG 
   fi
}


GetCurrentVersion () {
    echo "{ `curl -s http://localhost/glpi/ajax/telemetry.php | grep -v code` }" | jq -r '.glpi.version'
}

GetTelemetry () {
    echo "{ `curl -s http://localhost/glpi/ajax/telemetry.php | grep -v code` }" 
}


InstallBackupJob () {


  cat <<EOF > /etc/cron.daily/backup-glpi.sh
#!/bin/sh

# Backup Banco GLPI

mysqldump -u ${DBUSER} -p${DBPASS} ${DBNAME} | gzip > /var/www/html/glpi/files/_dumps/glpi-${VERSION}-\`date +%Y-%m-%d-%H-%M\`.sql.gz 

EXITVALUE=\$?
if [ \$EXITVALUE != 0 ]; then
    /usr/bin/logger -t GLPI "ALERT exited abnormally with [\$EXITVALUE]"
fi

chown apache.apache /var/www/html/glpi/files/_dumps/*.sql.gz

# Backup completo para dentro de /backup/

if [ ! -d /backup ]; then
  mkdir -p /backup
fi
tar -zcf /backup/backup-${VERSION}-\`date +%Y-%m-%d-%H-%M\`.tar.gz /var/www/html/glpi

EXITVALUE=\$?
if [ \$EXITVALUE != 0 ]; then
    /usr/bin/logger -t GLPI "ALERT exited abnormally with [\$EXITVALUE]"
fi


# Apagar backup com mais de 30d

find /var/www/html/glpi/files/_dumps/ -mtime +30 -delete
EXITVALUE=\$?
if [ \$EXITVALUE != 0 ]; then
    /usr/bin/logger -t GLPI "ALERT exited abnormally with [\$EXITVALUE]"
fi

exit 0

EOF

chmod +x /etc/cron.daily/backup-glpi.sh

}


EXECUTE="
Log 
DisableSELinux
DisableFirewall
InstallRepo
InstallDataBase
SetDataBaseSecure  
CreateDataBase
InstallApache
InstallPhp
SetPhpIni
Install
SetHttpConf
StartHttpd
DeployDataBase
SetPermission
InstallBackupJob
"


for job in $EXECUTE; do

  echo "Run $job... "

  $job >> $LOGS 2>&1

  if [ $? -eq 0 ]; then
    echo "ok" 
  else 
    echo "fail" 
  fi
done

GetTelemetry >> $LOGS
