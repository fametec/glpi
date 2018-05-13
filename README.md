# install_glpish

# Variaveis disponíveis

    VERSION="9.2.2"                      # Versão que deseja instalar
    TIMEZONE=America/Fortaleza           # Fuso horário
    FQDN="glpi.eftech.com.br"            # Nome de host para criar um virtualhost
    ADMINEMAIL="suporte@eftech.com.br"   # Email administrativo do virtualhost
    ORGANIZATION="EF-TECH"               # Nome da organização
    MYSQL_ROOT_PASSWORD=''               # Senha do usuário root do banco mysql
    DBUSER="glpi"                        # Nome de usuário do banco mysql
    DBHOST="localhost"                   # Endereço do banco mysql
    DBNAME="glpi"                        # Nome do banco
    # Cria senhas aleatórias
    DBPASS="E`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" # Cria uma senha aleatória
    MYSQL_NEW_ROOT_PASSWORD="C`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`" 
    
    
# Download

curl 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' -o install_glpi.sh 






