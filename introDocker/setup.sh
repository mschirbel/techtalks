#!/bin/bash

## Instalar para a maioria das distros de Linux

curl -fsSL https://get.docker.com/ | bash

## Instalar com APT

# apt update -y
# apt install apt-transport-https ca-certificates curl gnupg software-properties-common -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# apt install docker.io -y
# systemctl enable docker
# systemctl start docker
# docker -v

## Instalar com YUM

# yum install -y yum-utils device-mapper-persistent-data lvm2
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# curl -fsSL https://get.docker.com -o get-docker.sh
# yum install docker-ce docker-ce-cli containerd.io -y
# systemctl enable docker
# systemctl start docker
# docker -v

## Criar grupo e instalar os binários

echo "ao usar os binários, faça o reboot da máquina após a instalação."
echo "e sempre inicie o daemon do docker com o comando dockerd"

# groupadd docker
# gpasswd -a $USER docker
# chown "$USER":"$USER" /home/"$USER"/.docker -R
# chmod g+rwx "/home/$USER/.docker" -R
# usermod -a -G docker $USER
# dockerd &
# docker -v

## Instalar docker-compose

curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "troque a versão para obter a mais recente"

## Instalar docker-machine

#base=https://github.com/docker/machine/releases/download/v0.14.0 &&
 # curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
 # sudo install /tmp/docker-machine /usr/local/bin/docker-machine

echo "também deve trocar a versão"
