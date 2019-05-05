# Curso Docker

https://docs.docker.com/compose/aspnet-mssql-compose/

## O que é Docker?

Docker é uma ferramenta feita para construir, implantar e fazer funcionar aplicações usando containers.

É também conhecido como gerenciador de containers.

Foi criado pela **Docker, Inc** no ano de 2013. Desde a sua criação, seu código é aberto e pode ser visto [aqui](https://github.com/docker).

## Como o Docker funciona

explicar sobre o daemon

conexao com registries

processo de imagem -> container

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

### Daemon

É o componente responsável por ouvir a API e controlar os objetos do Docker, como containers, imagens, drivers de rede, volumes e outros. Veja mais [aqui](https://docs.docker.com/engine/docker-overview/).

O daemon pode se comunicar com diversos serviços do Docker.

Ao ser chamado, o daemon vai ter acesso e realizará alguma ação sobre algum objeto.

### Images

É um objeto de somente leitura, que serve como template para criar um container.
Podemos criar as nossas imagens, que por sua vez serão feitas sobre outras imagens.

Imagens tem o seguinte formato de identificação:

```
<nome da imagem>:<tag>
```

A tag é usada para diferenciar imagens com a mesma base. E usamos isso para versionar nossas imagens.

Uma imagem do Docker é composta de **layers**. Cada camada é uma alteração que pode ser feita na imagem base.

### Containers

Containers são instâncias de imagens. Podemos criar, iniciar, parar e deletar containers usando o client do Docker.

O client se conecta com o socket e é lido pelo daemon. Assim, temos a reprodução no sistema operacional do host.

Por padrão, um container é isolado do restante do host, inclusive de outros containers do Docker. Isso pode ser alterado, mas devemos configurar isso manualmente.

### Registry

São serviços, públicos ou privados, que permitem o armazenamento de imagens.

Temos como registry default do Docker o Docker Hub.

Lá é possível criar repositórios para versionar suas imagens, esses repositórios podem ser públicos ou privados.

O docker sempre vai procurar qualquer imagem localmente, se não encontrar no host, aí sim ele vai procurar nos registries públicos ou privados.

### Qual a diferença entre um container e uma VM?

A principal diferença entre eles, é que: em uma máquina virtual, as dependências da minha aplicação ficam instaladas no sistema operacional virtualizado, enquanto que, num ambiente de containers, essas dependências estão impacotadas dentro do meu container e não interagem com o meu sistema operacional.

Podemos ver mais [aqui](https://www.youtube.com/watch?v=L1ie8negCjc).

## Instalando o Docker

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
docker exec <container-id> -it bash
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

```python
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

Aqui temos algumas tarefas:

    - Criar um container de Apache usando Dockerfile
    - Trocar o arquivo index.html orinal pelo nosso modificado
    - Abrir a página inicial do Apache pelo IP do nosso host

Nosso Dockerfile:

```dockerfile
FROM httpd:latest
MAINTAINER mschirbel
EXPOSE 80
COPY ./index.html /usr/local/apache2/htdocs/
```

Nosso arquivo index.html novo:

```html
<html> 
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

Podemos acessar nossa página via IP da nossa máquina, ou até mesmo de dentro do container.

## Problemas encontrados

volumes & network

### O que são Volumes

como criar um

para o que serve

### Como funciona a rede do Docker

drivers

links entre containers

## Docker-compose

o que é

para o que serve

como instalar

## Rodando nosso sistema dotnet e MySQL

usando docker-compose

uma app dotnet que se comunica com o banco de dados.

## Bibliografia

- https://medium.com/@yannmjl/what-is-docker-in-simple-english-a24e8136b90b
- https://docs.docker.com/engine/docker-overview/
- https://unix.stackexchange.com/questions/243265/how-to-get-more-info-about-socket-file
- https://becode.com.br/o-que-e-api-rest-e-restful/
- https://docs.docker.com/engine/api/v1.24/
- https://github.com/docker
- https://www.youtube.com/watch?v=L1ie8negCjc
- https://hub.docker.com/_/mysql
- https://gitlab.com/mschirbel
- https://www.mundodocker.com.br/o-que-e-dockerfile/
- https://docs.docker.com/engine/reference/commandline/image_build/