# Curso Docker

## O que é Docker?

o que é o docker, como surgiu e código aberto

### Containers? O que são?

explicar como funciona, desde o simples até a camada do SO

### Qual a diferença entre um container e uma VM?

https://www.youtube.com/watch?v=L1ie8negCjc

usar imagem para isso, explicar como cada um funciona partindo do SO.

### Images e Registries

o que é uma imagem

para que serve um registry

## Como o Docker funciona

explicar sobre o daemon

conexao com registries

processo de imagem -> container

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