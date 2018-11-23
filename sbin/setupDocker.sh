#! /bin/bash
#Set up an environment with docker and docker-compose installed
apt update --assume-yes
apt upgrade --assume-yes
#Install packages to allow apt to use a repository over HTTPS:
apt-get install\
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common 

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce --assume-yes
#install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#Test the installations
docker run hello-world
docker-compose --version

