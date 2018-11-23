#! /bin/bash
docker stop $(docker ps -a -q)

docker image prune -f
docker container prune -f
docker network prune -f
docker volume prune -f

docker image prune -f -a
docker container prune -f
docker network prune -f
docker volume prune -f
