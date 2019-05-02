# Curso Docker

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

### Containers? O que são?

explicar como funciona, desde o simples até a camada do SO

### Qual a diferença entre um container e uma VM?

https://www.youtube.com/watch?v=L1ie8negCjc

usar imagem para isso, explicar como cada um funciona partindo do SO.

### Images e Registries

o que é uma imagem

para que serve um registry

## Instalando o Docker

Mostrar o script que foi feito para isso - não vou instalar, pois vou usar o play with docker

## Passos para verificar se a instalação está correta

tem conexão com o docker daemon

se tem conexao com o dockerhub

verificar versao do composer

## Rodando um container de MySQL

comando para rodar um container de mysql - usando senha para root

entrar no container

executar comandos de mysql dentro do contaiiner

## Explicar sobre Dockerfile

o que é

como escrever

por que eu deveria escrever um?

## Rodando um container de Tomcat

mostrar o Dockerfile

falar sobre a alteração na senha de manager

construir a imagem

rodar o container e visitar a página web

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

uma app dotnet que se comunica com o banco de dados 