# INSTALL_GLPI.SH

Este script irá instalar o glpi em um sistema operacional CentOS 7 Minimal. 


# DOWNLOAD

    curl 'https://raw.githubusercontent.com/fameconsultoria/glpi/master/install_glpi.sh' -o install_glpi.sh 


# VARIÁVEIS

Dentro do script existem algumas variaveis que podem ser alteraradas antes da instalação.


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
    
    

# INSTALAÇÃO

    sh install_glpi.sh


Após a instalação será gerado um arquivo ~/install_glpi.log com as credenciais do banco e demais variaveis que foram utilizada pelo sistema. 



# CURSOS

https://www.fametreinamentos.com.br


# CONSULTORIA E SUPORTE

https://www.fameconsultoria.com.br

https://www.fametec.com.br
    
contato@fameconsultoria.com.br


# FAMETEC DOCKER GLPI

One Paragraph of project description goes here

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc


