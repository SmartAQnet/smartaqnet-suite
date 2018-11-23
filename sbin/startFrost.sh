#! /bin/bash
# Set up container: Frost-Server-GUI and Frost-Server-db
cd ..
if test -z "$smartaqnethome"
then echo "export smartaqnethome=$(uname -n).teco.edu" > /etc/environment
fi
echo "export smartaqnethome=$(uname -n).teco.edu" > /etc/environment
source /etc/environment
echo $smartaqnethome
# Mkdir for volumes
mkdir -p volumes/frost/postgis_data_volume
mkdir -p volumes/frost/postgis_backup_volume
# Set up SensorThingsServerDocker
git clone https://github.com/BowenWang29/docker-SensorThingsServer.git .//Frost-Server
git clone https://github.com/BowenWang29/docker-postgres-wale.git .//docker-postgres-wale
docker-compose -f ./Frost-Server/docker-compose.yml up --build -d
#docker-compose -f ./docker-postgres-wale/docker-compose.yml up --build -d
sleep 3m
docker-compose -f ./Frost-Server/docker-compose.yml exec database psql -U sensorthings -d sensorthings -c 'CREATE EXTENSION IF NOT EXISTS "postgis"' && \
#docker-compose -f ./docker-postgres-wale/docker-compose.yml exec database psql -U sensorthings -d sensorthings -c 'CREATE EXTENSION IF NOT EXISTS "postgis"' && \
docker-compose -f ./Frost-Server/docker-compose.yml exec database psql -U sensorthings -d sensorthings -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"' && \
#docker-compose -f ./docker-postgres-wale/docker-compose.yml exec database psql -U sensorthings -d sensorthings -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"' && \
curl -X POST http://localhost:8080/FROST-Server/DatabaseStatus
# Set up landoop and sftp
#sleep 3m
#docker-compose -f ./docker-compose.yml up --build -d
#docker run --rm --net=host -e ADV_HOST=$smartaqnethome landoop/fast-data-dev -d
# Set up ST2SFTP
# Set up FrostFranz
#sleep 3m
#docker-compose -f ./FrostyFranz/docker-compose.yml up --build -d
