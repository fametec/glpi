# INSTALL_GLPI.SH

Este script irá instalar o glpi em um sistema operacional CentOS 7 Minimal. 


## DOWNLOAD

    curl 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' -o install_glpi.sh 


## VARIÁVEIS

Dentro do script existem algumas variaveis que podem ser alteradas antes da instalação.


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
    
    

## INSTALAÇÃO

    sh install_glpi.sh


Após a instalação será gerado um arquivo ~/install_glpi.log com as credenciais do banco e demais variaveis que foram utilizada pelo sistema. 



## CURSOS

https://www.fametreinamentos.com.br


## CONSULTORIA E SUPORTE

https://www.fameconsultoria.com.br

https://www.fametec.com.br
    
contato@fameconsultoria.com.br

