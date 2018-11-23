# smartaqnet-suite
The collection of repositories for smartaqnet that sets up a docker based infrastructure including `Frost-Server`(GUI and Database), `FrostyFranz`, `kafka-env-cluster`(Kafka and Zookeeper), `sftp`(sftp-to-sensorthings and sensorthings-to-sftp). Besides, there is a demo use case(`KrigingExample`) that applies Kriging algorithm on the data streamed from the system. In the folder `sbin` you can find scripts for quick set-up. Docker volumes are persisted in the folder `volumes`. Further information is found in the folder of each submodule.

Generally all `.bu` files can be removed.

## Quick start:
* Start Frost-Server-GUI and Frost-Server-Datebase:
	`./sbin/startFrost.sh`
* Set up an landoop container: a kafka contianer if you just need a single node kafka cluster
	`./sbin/startLandoop.sh`
* Stop the  landoop container:
	`./sbin/stopLandoop.sh`
* Set up the docker environement:
	`./sbin/setupDocker.sh`
* Reset the docker environment: stop and prune all containers, prune all images and volumes
	`./sbin/resetDocker.sh`
* FrostyFranz, kafka-cluster or sftp is set up using `docker-compose` in their own folders.

## Current setup:
![Architecture used in KrigingExample](https://projects.teco.edu/projects/ap-3-data/repository/smartaqnet-suite/revisions/master/raw/Kappa.png "CurrentSetup") 


To set up a cluster shown in the figure above you'll need 7 machines. One machine for Frost-Server, four machines  for KFC0 that serves as a production-cluster and four machines for KFC1 that backs up data from KFC0.

### Frost-Server
1. Setup Frost-Server with the build-in script in `./sbin/startFrost.sh`
2. Setup FrostyFranz with `docker-compose` command. Note that the domain and port need to be specified in `./FrostyFranz/Helper.py` and `./FrostyFranz/FrosyFranz.py`

### KFC
1. Setup zookeeper contianers in one node and kafka containers in the other nodes in the same KFC. Settings including domain/port/role need to be modified by editing `./kafka-env-cluster/docker-compose.yaml` and `./kafka-env-cluster/.env`. After the modification, run `docker-compose` on each node. Please start zookeeper contianers first.
2. For KFC0, after setting up the cluster, run `./kafka-env-cluster/init-topic.sh` in one of the kafka __container__ in __KFC0__ to create topics with specified replication and persist settings. Please modify the script with the correct zookeeper domain and port.
3. For KFC1, after setting up the cluster, run `./kafka-env-cluster/init-mirrormaker.sh` in one of the kafka __node__ in __KFC1__ to initialze the MirrorMaker that backs up data from KFC0 to KFC1.

__Note:__  both scripts (`./kafka-env-cluster/init-topic.sh` and `./kafka-env-cluster/init-mirrormaker.sh`) can be modified to run on the node or in the container. Further more, the execution is not limited in __KFC0__ or __KFC1__ because topic initialization and MirrorMaker can be executed on any machine with kafka client installed.


## File structure
The tree structure of the files is as follows:

├── Frost-Server: Creates FROST-Server-GUI and FROST-Server Database

│   ├── docker-compose.yml

│   ├── Dockerfile_db

│   ├── Dockerfile_gui

│   ├── LICENSE

│   ├── README.md

│   └── scripts

│       ├── build-image.sh.bu

│       ├── docker-entrypoint.sh

│       ├── docker-entrypoint.sh.bu

│       ├── fix-acl.sh

│       ├── initdb-postgis.sh

│       ├── setup-wale.sh

│       └── update-postgis.sh

├── FrostyFranz: Bridge between FROST-Server and Kafka

│   ├── docker-compose.yml

│   ├── Dockerfile

│   ├── FrostyFranz.py

│   ├── Helper.py

│   └── README.md

├── kafka-env-cluster: Creates two types of nodes in a Kafka cluster: Kafka and Zookeeper

│   ├── consumer.py

│   ├── docker-compose.yaml

│   ├── .env

│   ├── init-mirrormaker.sh

│   ├── init-topics.sh

│   ├── kafka-connect

│   │   └── jars

│   ├── producer.py

│   ├── README.md

│   └── run

├── KrigingExample: A demo use case uses the system

│   ├── 1.1. ParquetToFrost.ipynb

│   ├── 1.2. ParquetToFrost.ipynb

│   ├── 1.3. ParquetToKafka.ipynb

│   ├── 1. ParquetToFrost.ipynb

│   ├── 2.1. FrostServerToKafka.ipynb

│   ├── 2. FrostServerToKafka.ipynb

│   ├── 3.1 PFF.ipynb

│   ├── 3. PFF.ipynb

│   ├── 4.1 KrigingClient.ipynb

│   ├── 4.2 KrigingClientFromKafkaFromSensorThings.ipynb

│   ├── 4. KrigingClient.ipynb

│   ├── 5.0 Kriging Use Case.ipynb

│   ├── arcgisTryOut.ipynb

│   ├── foliumTryOut.ipynb

│   ├── gmapTryOut.ipynb

│   ├── Helper.py

│   ├── KrigingExample.jpg

│   ├── README.md

│   └── Untitled.ipynb

├── README.md

├── sbin: Quick start scripts

│   ├── resetDocker.sh

│   ├── setupDocker.sh

│   ├── startFrost.sh

│   ├── startFrost.sh.bu

│   ├── startLandoop.sh

│   └── stopLandoop.sh

├── sftp

│   ├── docker-compose.yml

│   ├── sftp2st

│   │   ├── DataLogger.py_bak

│   │   ├── docker-compose.yml

│   │   ├── Dockerfile

│   │   ├── FileWatcher.py

│   │   └── Helper.py

│   └── st2sftp

│       ├── DataLogger.py

│       ├── docker-compose.yml

│       ├── Dockerfile

│       ├── FileWatcher.py_bak

│       ├── Helper.py

│       └── Helper.pyc

└── volumes: Volumes for docker

└── frost