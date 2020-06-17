# Curso Docker

## Objetivo

O objetivo deste curso é apresentar os conceitos fundamentais do Docker. Mostrar a sua arquitetura e alguns comandos básicos.

O conteúdo abordado inclui:

1. Processos do Docker
2. REST API
3. Images
4. Containers
5. Regitries
6. Volumes
7. Network
8. Dockerfile
9. Docker-compose
10. Exemplos práticos
11. Exercícios extras

## O que é Docker?

Docker é uma ferramenta feita para construir, implantar e fazer funcionar aplicações usando containers.

É também conhecido como gerenciador de containers.

Foi criado pela **Docker, Inc** no ano de 2013. Desde a sua criação, seu código é aberto e pode ser visto [aqui](https://github.com/docker).

Leia um [artigo bem bacana](https://medium.com/@yannmjl/what-is-docker-in-simple-english-a24e8136b90b).

## Como o Docker funciona

O Docker usa uma arquitetura de **cliente-servidor**. O client e o server, podem ou não, estar na mesma máquina.

O cliente é chamado de **docker client**.
O servidor é chamado de **docker daemon**.

Eles se comunicam por uma Unix Rest API, essa comunicação é feita por meio de um socket.

Podemos ver mais sobre os *endpoints* do Docker [aqui](https://docs.docker.com/engine/api/v1.24/).

##### O que é uma REST API?

Uma REST API é uma interface que contém um conjunto de operações bem definidas sobre recursos.

Você pode entender mais sobre API's clicando [aqui](https://becode.com.br/o-que-e-api-rest-e-restful/).

##### O que é um socket?

Um socket é um arquivo que serve para trocar informações entre processos.

Você pode entender mais sobre sockets lendo essa [thread no stackoverflow](https://unix.stackexchange.com/questions/243265/how-to-get-more-info-about-socket-file).

No Docker, podemos encontrar esse socket em */var/run/docker.sock*.

---

### Client 

É a forma como o usuário vai se comunicar com a API do Docker, usando comandos como:

```s
docker ps
```

É possível também se comunicar com diversos daemons.

Para ler mais sobre isso, veja [esse gist](https://gist.github.com/kekru/4e6d49b4290a4eebc7b597c07eaf61f2).

### Daemon

É o componente responsável por ouvir a API e controlar os objetos do Docker, como containers, imagens, drivers de rede, volumes e outros. Veja mais [aqui](https://docs.docker.com/engine/docker-overview/).

O daemon pode se comunicar com diversos serviços do Docker.

Ao ser chamado, o daemon vai ter acesso ao socket e realizará alguma ação sobre algum objeto.

O processo é o seguinte: O usuário entra com um comando que chama o socket, este, será ouvido pelo daemon. O daemon, realizará alguma ação da API sobre algum objeto.

O socket do Docker pode ser encontrado em:

```
ls -la /var/run/docker.sock
```

### Images

É um objeto somente de leitura, que serve como template para criar um container.
Podemos criar as nossas imagens que, por sua vez, serão feitas sobre outras imagens.

Imagens tem o seguinte formato de identificação:

```
<nome da imagem>:<tag>
```

A tag é usada para diferenciar imagens com a mesma base. E usamos isso para versionar nossas imagens.

Uma imagem do Docker é composta de **layers**. Cada camada é uma alteração que pode ser feita na imagem base.

Como a imagem é composta de layers, o Docker vai criando containers intermediários para realizar os processos descritos no Dockerfile. Após realizar o comando, ele salva esse container intermediário para ser usado no próximo comando, e depois remove o container intermediário, como mostrado abaixo:

```
Status: Downloaded newer image for mysql:5.7.26
 ---> 2f52e94d8acb
Step 2/7 : MAINTAINER marceloschirbel
 ---> Running in d19655b10b43
Removing intermediate container d19655b10b43
 ---> 5482816cf552
Step 3/7 : ENV MYSQL_DATABASE=marcelo
 ---> Running in 2690920f4b02
Removing intermediate container 2690920f4b02
 ---> 6adb63a10661
Step 4/7 : ENV MYSQL_RANDOM_ROOT_PASSWORD=true
 ---> Running in f211ab2ffe5c
Removing intermediate container f211ab2ffe5c
 ---> ddcfe3fa132d
Step 5/7 : ENV MYSQL_USER=c6docker
 ---> Running in 66c9eec412a7
Removing intermediate container 66c9eec412a7
 ---> 2b1f4de6311e
Step 6/7 : ENV MYSQL_PASSWORD=docker
 ---> Running in 68db7a454038
Removing intermediate container 68db7a454038
 ---> 20ea394ca126
Step 7/7 : COPY ./setup.sql /docker-entrypoint-initdb.d/
 ---> aa0d483ba2bc
Successfully built aa0d483ba2bc
Successfully tagged httpdmysql_db:latest
```

Caso você queria ver todo o histórico das camadas:

```
docker history <image-id>
```

Veja que estamos baixando a imagem do mysql5.7 e vamos executar diversos comandos dentro dela. É criado containers intermediários que logo serão removidos, até que no final, uma imagem fique pronta com tudo o que escrevemos no Dockerfile.

Se verificarmos as imagens:

```
docker image ls -a
```

Veja que aparece a imagem que criamos com o mesmo ID que apareceu na build, **aa0d483ba2bc**:

```
httpdmysql_db       latest              aa0d483ba2bc        2 minutes ago        373MB
```

Para juntar todas as camadas em uma só imagem, o Docker usa o AUFS(Another Union FileSystem), que é uma forma de Union Mount, uma *feature* que permite combinar vários diretórios em um único, que contém tudo.

Se você quiser saber mais sobre como o Docker faz essa "ligação" entre as diversas camadas, leia sobre [Union Mount and Docker](https://medium.com/@paccattam/drooling-over-docker-2-understanding-union-file-systems-2e9bf204177c). Ou sobre [AUFS](https://medium.com/@jessgreb01/digging-into-docker-layers-c22f948ed612).

### Containers

Containers são instâncias de imagens. Podemos criar, iniciar, parar e deletar containers usando o client do Docker.

O client se conecta com o socket e é lido pelo daemon. Assim, temos a reprodução no sistema operacional do host.

Por padrão, um container é isolado do restante do host, inclusive de outros containers do Docker. Isso pode ser alterado, mas devemos configurar isso manualmente.

O processo de criação de containers é realizado pelo *containerd*. Uma funcionalidade do *kernelspace*, no qual construímos uma camada de abstração entre o código e as chamadas de sistema, usando containers. É responsável por controlar o ciclo de vida de imagens, containers, storage e networks. [Aqui](https://github.com/containerd/containerd) temos o código fonte do *containerd* e sua explicação original.

Leia mais sobre isso [neste](https://imasters.com.br/devsecops/o-que-e-o-containerd) artigo bem bacana.

### Isolamento de Containers

Para fazer o isolamento, tanto de containers para containers e do container para o host, o Docker usa algumas *features* do SO para tal.

##### Namespaces

Namespaces são uma característica do Kernel do Linux que dá uma camada de isolamento para o container. O Docker usa isso para impedir o contato com o sistems *host*.

Existem alguns tipos de Namespaces:

1. process ID
2. mount
3. IPC(inter process communication)
4. user
5. network

Todas essas são usadas pelo Docker, e devem ser abusadas pelos usuários, pois além de proteger o host, oferecem mais segurança para a aplicação.

Leia mais na [documentação oficial](https://docs.docker.com/engine/security/userns-remap/).

##### CGroups

Cgroups são outra característica do Kernel, que permite limitar os recursos alocados para cada container, sem que o container saiba que existe mais para usar. Podemos usar isso para:

1. CPU
2. Memoria
3. Banda de Rede
4. Disco
5. Prioridade de processos

Por exemplo, podemos dizer para um container usar uma certa quantidade de CPU, como no comando abaixo:

```
docker run -d --name='cpu-test' --cpuset-cpus=0 --cpu-shares=20 ubuntu:latest
```

Veja [este](https://medium.com/@kasunmaduraeng/docker-namespace-and-cgroups-dece27c209c7) artigo para entender mais.

##### SELinux

SELinux é um sistema de rótulos. Cada processo tem um rótulo e cada arquivo no SO tem um rótulo.
E escrever regras para acesso de rótulos de processos a rótulos de objetos é chamado de *policy*.

SELinux significa **Security Enhanced Linux**.

O docker usa isso para evitar o contato de containers com containers e do container com os processos do Host de uma forma segura e eficar.

Pode-se ler mais sobre isso [aqui](https://opensource.com/business/13/11/selinux-policy-guide)

Se quiser um guia detalhado, clique [aqui](https://opensource.com/business/13/11/selinux-policy-guide).

### Registry

São serviços, públicos ou privados, que permitem o armazenamento de imagens.

Temos como registry default do Docker o Docker Hub.

Lá é possível criar repositórios para versionar suas imagens, esses repositórios podem ser públicos ou privados.

O docker sempre vai procurar qualquer imagem localmente, se não encontrar no host, aí sim ele vai procurar nos registries públicos ou privados.

Caso queira ver o registry local do Docker no Play-With-Docker:

```
ls -la /var/lib/docker/image/
```

Caso queira ler mais sobre, clique [aqui](http://www.scmgalaxy.com/tutorials/location-of-dockers-images-in-all-operating-systems/).

### Qual a diferença entre um container e uma VM?

A principal diferença entre eles, é que: em uma máquina virtual, as dependências da minha aplicação ficam instaladas no sistema operacional virtualizado, enquanto que, num ambiente de containers, essas dependências estão impacotadas dentro do meu container e não interagem com o meu sistema operacional.

Outras diferenças estão, por exemplo, na camada de segurança. Enquanto a VM tem uma segurança elevada, o container depende muito das proteções oferecidas pelo Host.

Quanto a utilização de disco, a VM gasta muito mais do que um container, este por sua vez, somente consome aquilo que foi utilizado pela aplicação e arquivos internos.

Uma VM demora muito mais tempo para iniciar, pois deve carregar todo o sistema operacional, bem como carregar a aplicação. Enquanto que no container, só é necessário carregar a aplicação.

A portabilidade é outro fator que realmente favorece o container. Pois temos a liberdade de criar imagens e subir para repositórios públicos e compartilhar com diversas pessoas no mundo em questão de segundos, enquanto que uma VM pode causar certas dificuldades.

Podemos ver mais [aqui](https://www.youtube.com/watch?v=L1ie8negCjc).

## Instalando o Docker

Antes de começar a parte prática, baixe o material do curso na [página do Github](https://github.com/mschirbel/curso-docker).

Ou use o comando abaixo:

```git
git clone https://github.com/mschirbel/curso-docker.git
cd curso-docker
ls -la
```

No Docker para Windows temos a possibilidade de escolher entre Windows containers e Linux Containers. Você pode ler mais sobre a diferença entre eles [aqui](https://containerjournal.com/2016/10/28/linux-vs-windows-containers-whats-difference/).

Mas ambos são feitos para abrigarem aplicações em containers e funcionarem nativamente, ou seja, sem máquinas virtuais. Ambos possuem a mesma portabilidade e as mesmas funcionalidades.

Por hora, trabalharemos somente com Linux Containers.

### Linux

Temos o script **setup.sh** com as instalações usando dois package managers, *apt* e *yum*. Também temos a instalação do Docker com os binários e download do *docker-compose* e *docker-machine*.

### Windows

Devemos usar o Docker ToolBox, disponibilizado pela Docker, Inc, disponível [aqui](https://docs.docker.com/docker-for-windows/install/).

Caso queira ver um tutorial, assista [este](https://www.youtube.com/watch?v=ymlWt1MqURY) vídeo.

### Passos para verificar se a instalação está correta

Para verificarmos se a nossa instalação está correta, devemos checar se:

1. temos acesso a CLI do Docker Client
2. temos acesso ao daemon

Para testar a CLI:

```
docker -v
```

Para testar o daemon:

```
docker ps
```

## Primeiro Container

Vamos agora, rodar nosso primeiro container, com ele testaremos se temos acesso ao registry default do Docker, o Docker Hub:

```
docker run hello-world
``` 

Perceba que, a primeira coisa que o Docker fez foi procurar a imagem localmente:

```
Unable to find image 'hello-world:latest' locally
```

Como não especificamos nenhuma tag, por default foi usada a *latest* que é a última versão daquela imagem.

Após isso, o Docker fez um **pull** da imagem em camadas:

```
latest: Pulling from library/hello-world
1b930d010525: Pull complete
```

Após isso temos o output do container.

Podemos ver a imagem que foi baixada:

```
docker image ls
```

Podemos ver o status do container:

```
docker ps -a
```

## Rodando um container de MySQL

Nossa tarefa é:

- Criar o container com:
    1. Um nome especial
    2. Senha de root
- Entrar no container
- Executar alguns comandos de MySQL
- Remover o container

### Para criar nosso container

```
docker run --name mysql-test -e MYSQL_ROOT_PASSWORD=12qwaszx -d mysql:latest
```

O parâmetro *--name* é para referenciarmos o nome do nosso container. E o parâmetro *-e* é para indicarmos alguma variável de ambiente que desejamos ter no nosso container.

No caso do MySQL, temos na [documentação oficial](https://hub.docker.com/_/mysql) que a variável **MYSQL_ROOT_PASSWORD** é a senha do usuário root.

O parâmetro *-d* é para o container estar em *detach mode*, ou seja, ele rodará em background do nosso SO.

E por fim, indicamos qual imagem e sua tag, queremos rodar.

Vejamos agora nosso container:

```
docker ps
```

Podemos ver nossas imagens:

```
docker image ls -a
```

### Agora, queremos entrar no nosso container

```
docker exec -it <container-id> bash
```

Esse comando executará o comando **bash** dentro do container em modo interativo(*-i*) e com um pseudo TTY(*-t*), que é um terminal.

### Executando comandos no container

Podemos executar comandos simples de Unix:

```
hostname
date
ls -la /
```

Mas podemos ver que existe um processo do MySQL rodando:

```
mysql --version
mysqld
```

Então, podemos entrar no banco de dados, pois temos um usuário e senha:

```
mysql -uroot -p12qwaszx
```

Agora podemos executar comandos de MySQL no nosso container:

```mysql
show databases;
create database marcelo;
use marcelo;
create table pessoas(codigo int(3), primary key (codigo));
```

### Excluindo o container

Para vermos quais são os containers do nosso Docker:

```
docker ps -a
```

Docker ps mostra somente os que estão rodando, o parâmetro *-a* mostra até os que estão parados.

Para remover um container:

```
docker container rm <container-id>
```

Isso vai dar um erro, pois o container está rodando. Ou paramos o container ou forçamos a remoção.

Para parar um container:

```
docker container stop <container-id>
```

Para remover com force:

```
docker container rm -f <container-id>
```

Para remover todos os containers:

```
docker container rm -f $(docker ps -aq)
```

## Dockerfile

Bom, como vimos, é muito fácil subir um container. Mas os comandos podem ser extensos, e por muitas vezes, podemos nos confundir nos parâmetros.

Sendo assim, seria viável termos uma forma de armazenarmos um template de uma imagem. E temos, usando um Dockerfile.

Dockerfile é um arquivo onde podemos definir e preparar todo o ambiente a partir de um script de execução feito pelo próprio Docker.

Como se fosse uma receita de bolo.

Existem algumas instruções possívels no Dockerfile:

```dockerfile
FROM # informa qual será a imagem base, esse campo é o único obrigatório
MAINTAINER # nome da pessoa que fez a nova imagem
RUN # executa um comando dentro da imagem
CMD # buffer de execução de um comando que pode ser feito via cli
LABEL # adiciona metadados
EXPOSE # expõe portas para o host
ENV # passa variáveis de ambientes para a imagem
ADD # adiciona arquivos locais ou de URL para dentro da imagem
COPY # copia arquivos ou diretórios para dentro da imagem
ENTRYPOINT # informa um comando para ser executado sempre quando a imagem iniciar
VOLUME # mapeia um diretório no host para persistir os dados de um diretório da imagem
USER # com qual usuário serão executadas as instruções de criação da imagem
WORKDIR # qual diretório trabalha
ONBUILD # trigger para ações
```

## Rodando um container de Apache Web Server

Para verificarmos os arquivos, entre na nossa pasta do exemplo:

```
cd curso-docker/apache-example/
```

Aqui temos algumas tarefas:

    - Criar uma imagem de Apache usando Dockerfile
    - Trocar o arquivo index.html orinal pelo nosso modificado
    - Subir um container com a nossa imagem nova
    - Abrir a página inicial do Apache pelo IP do nosso host

Nosso Dockerfile:

```dockerfile
FROM httpd:latest
MAINTAINER marceloschirbel
EXPOSE 80
COPY ./index.html /usr/local/apache2/htdocs/
```

Estamos usando a imagem mais nova do Apache.

Depois usamos o **EXPOSE** para comunicar ao host qual porta estamos usando. Lembre-se que isso **não** faz a publicação da porta, isso deve ser feito pelo desenvolvedor, usando o parâmetro *--publish*.

Logo depois, copiamos nosso arquivo index.html para o diretório padrão do Apache.

Nosso arquivo index.html novo:

```html
<html>
    <head>
        <meta charset="UTF-8">
        <title>AULA TOP de Docker</title>
    </head>
    <body>
        <h1> Curso Docker</h1>
        <h2> Olha que aula TOP</h2>
        <h3> Se isso aqui abriu, é porque funcionou!</h3>
    </body>    
</html>
```

Para construir nossa imagem a partir do Dockerfile:

```
docker build . -t cursodocker
```

Você pode ver todos os parâmetros para build [aqui](https://docs.docker.com/engine/reference/commandline/image_build/).

Para criar um container com a nossa nova imagem:

```
docker run -p 80:80 -d cursodocker
```

Para o parâmetro de publish, temos que o primeiro valor é a porta usada na máquina host, e o segundo é o valor usado pela aplicação dentro do container.

Podemos acessar nossa página via IP da nossa máquina, ou até mesmo de dentro do container.

## Problemas encontrados

Aqui encontramos dois grandes problemas:

    1. nossos containers estão incomunicáveis
    2. se apagarmos o nosso banco de dados, perderemos todos os dados.

Isso pode ser resolvido usando Networks e Volumes.

### O que são Volumes

Volumes é o mecanismo que o Docker usa para persistir dados que estão nos containers.

É um mapeamento do FS do container, que será replicado em algum diretório do host.
Podem ser encontrado em:

```
ls -la /var/lib/docker/volumes/
```

Podemos usar diferentes volumes nos containers, por isso, uma migração de dados fica realmente fácil.

Funcionam tanto em Linux e Windows containers.

Pode-se ler mais sobre [aqui](https://docs.docker.com/storage/volumes/), que é o link da documentação oficial.

Também tem [esse](https://www.mundodocker.com.br/montando-volumes-docker/) artigo do Mundo Docker, que é bem interessante também.

### Como funciona a rede do Docker

Com a rede do Docker, podemos conectar containers ou até mesmo a objetos que não são do Docker.

O sistema de networkd do Docker é volátil. Isso se deve pelo uso de drivers. Existem muitos pode default e podemos até instalar alguns novos.

Alguns deles:

    1. **bridge** usado para containers que não precisam de comunicação com nenhum outro serviço.
    2. **overlay** usado para conectar múltiplos containers e serviços.
    3. **none** não há rede. Geralmente esse é usado quando vc quer um *custom driver*.

Você pode ler mais sobre networks na [documentação oficial](https://docs.docker.com/network/).

[Aqui](https://medium.com/dockerbr/docker-trabalhando-com-network-64d0bf66263f) também tem um artigo bem legal sobre.

## Docker-compose

Docker Compose é uma ferramenta para auxiliar a rodar múltiplos containers, conectados ou não.

Docker Compose usa YAML, uma linguagem declarativa, semelhante ao Dockerfile, para produzir sua stack.

Para aprender mais sobre YAML, veja [este](https://www.tutorialspoint.com/yaml/index.htm) e [este](https://gettaurus.org/docs/YAMLTutorial/) tutoriais.

Usamos o Compose para evitar problemas em administrar múltiplas stacks, visto que o processo que usamos é altamente manual, logo, temos grande chance de erro humano.

Caso queira alguns exemplo, veja [aqui](https://blog.alura.com.br/compondo-uma-aplicacao-com-o-docker-compose/) e [aqui](https://imasters.com.br/banco-de-dados/docker-compose-o-que-e-para-que-serve-o-que-come).

Para ler a documentação oficial, clique [aqui](https://docs.docker.com/compose/).

O Docker compose tem alguns comandos essenciais:

```sh
docker-compose up
# Para criar e iniciar os containers descritos no arquivo
```

```sh
docker-compose down
# Para pausar e destruir os containers descritos no arquivo
```

```sh
docker-compose stop
# Para pausar descritos no arquivo
```

```sh
docker-compose start
# Para iniciar os containers descritos no arquivo
```

```sh
docker-compose restart
# Para pausar e iniciar os containers descritos no arquivo
```

```sh
docker-compose config
# Para validar o arquivo
```

O nome do arquivo, por padrão é **docker-compose.yml**. Mas caso você queira um arquivo com o nome diferente, todos os comandos devem conter o parâmetro *-f*:

```sh
docker-compose up -f frontend.yml
# Para criar e iniciar os containers descritos no arquivo frontend.yml
```

## Rodando nossa LAMP Stack

LAMP: Linux + Apache + MySQL + PHP.

Para verificarmos os arquivos, entre na nossa pasta do exemplo:

```
cd curso-docker/httpd+mysql/
```

Veja que temos algumas pastas e um arquivo docker-compose.yml.

Na pasta *webserver* temos os arquivos necessários para criar a imagem do Apache com PHP.

Nosso Dockerfile para a imagem do Apache+PHP:

```dockerfile
FROM php:7.2.1-apache
MAINTAINER marceloschirbel
RUN docker-php-ext-install pdo pdo_mysql mysqli
COPY ./index.php /var/www/html/
```

E nosso arquivo index.php:

```php
<?php
$servername = "db-c6-docker:3306";
$username = "c6docker";
$password = "docker";
// Create connection
$conn = new mysqli($servername, $username, $password);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully to the Database";
?>
```

Na pasta *database* temos os arquivos para criar nossa imagem do MySQL com alguns dados já inclusos.

Nossa imagem de MySQL será desse jeito:

```dockerfile
FROM mysql:5.7.26
MAINTAINER marceloschirbel
ENV MYSQL_DATABASE=c6
ENV MYSQL_RANDOM_ROOT_PASSWORD=true
ENV MYSQL_USER=c6docker
ENV MYSQL_PASSWORD=docker
```

E nosso script para popular o banco:

```sql
USE marcelo;
CREATE TABLE People (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Cargo varchar(255),
    Team varchar(255) 
);
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (2567, 'Schirbel', 'Marcelo', 'Estagiario', 'MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (3623, 'Cruz', 'Fernando', 'Gestor', 'SO e MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (2579, 'Corassini', 'Nilton', 'Analista', 'MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (9800, 'Fagundes', 'Eduardo', 'Analista', 'MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (1365, 'Gusmao', 'Andre', 'Estagiario', 'MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (7789, 'Assinato', 'Raissa', 'Estagiario', 'MW');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (4241, 'Lins', 'Douglas', 'Estagiario', 'SO');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (2245, 'Freitas', 'Matheus', 'Analista', 'BD');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (6672, 'Guth', 'Lucas', 'Estagiario', 'BD');
INSERT INTO People(PersonID, LastName, FirstName, Cargo, Team) VALUES (8889, 'Santos', 'Gabriel', 'Analista', 'SO');
```


No nosso arquivo *docker-compose.yml*, temos o modo como subir essa stack. Incluiremos um Adminer, uma web console para visualizar e editar nosso banco de dados.

```yaml
version: '3'
services:
  web:
    build: webserver/.
    container_name: wb-c6-docker
    ports:
      - 80:80
    networks:
      - overlay
    depends_on:
      - db
  db:
    build: database/.
    restart: always
    container_name: db-c6-docker
    volumes:
      - mysqldbv:/var/lib/mysql
    networks: 
      - overlay
      
  adminer:
    image: adminer
    restart: always
    container_name: ad-c6-docker
    ports:
      - 8080:8080
    networks:
      - overlay
    depends_on:
      - db
      - web

volumes:
  mysqldbv:

networks:
  overlay:
```

Para subir a stack, use o comando:

```
docker-compose up -d
```

Usamos o parâmetro *-d* para estar *detach mode*, logo não veremos todo o output na tela e o processo ocorrerá em background.

Podemos testar a chamada de URL com a porta 80 e 8080. 

Na porta 80 nossa página index.php nos dirá se houve sucesso na conexão com o Banco de Dados.
Na porta 8080 teremos acesso a console do Adminer

Com isso, testamos a nossa network. E ela funciona. Agora vamos testar os volumes.

Para isso, copie o script setup.sql para dentro do container do MySQL:

```
cd database
docker cp ./setup.sql <container-name>:/tmp/
```
Agora entre no Banco e verifique se a tabela foi criada:

```
docker exec -it <container-name> /bin/bash
cd /tmp/
mysql -uc6docker -pdocker < setup.sql
use c6;
show tables;
select * from People
```

Agora vá na página do Adminer, logue com as credenciais e veja se podemos administrar a tabela.

Agora, apague o container do DB e suba somente ele:

```
docker ps
docker rm -f <container-db-name>
docker-compose up -d db
```

Para destruir nossa stack:

```
docker-compose down
```

## Extra

Dentro da pasta `extra-exercises` deixei alguns exercícios para praticar. Quaisquer dúvidas, podem me chamar.

## Recomendações

Aqui farei algumas recomendações de cursos livres, artigos e páginas com conteúdo sobre Docker e também DevOps:

1. FAUN - Comunidade sobre DevOps, pode ser lido sobre [aqui](https://medium.com/faun)
2. Docker from A to Z, um [ótimo curso](https://www.udemy.com/a-practical-guide-to-docker-swarm-and-jenkins/learn/v4/overview)
3. Docker, Jenkins e Kubernetes - veja [aqui](https://www.udemy.com/missao-devops-jenkins-em-larga-escala-docker-e-kubernetes/learn/v4/overview).
4. LinuxTIPS - canal excelente sobre DevOps e tem ótimos vídeos de Docker, [aqui](https://www.youtube.com/user/linuxtipscanal).
