# kafka-env-cluster

This repo helps you set up a kafka cluster with zookeeper and kafka docker images from confluent. Modify the corresponding **docker-compose.yaml** and **.env** to distinguish nodes with different roles.

## Quick start:
After modifying **docker-compose.yaml** and **.env**, run
```bash
docker-compose up -d zk_1
docker-compose up -d kafka_1
```
to start a cluster with a zk container and a kafka container locally.
## Zookeeper
The Zookeeper-shell can be accessed in the container as follows:
```bash
zookeeper-shell smartaqnet-0-node0:22181
```
## Kafka
Example: Creation of a topic with the number of replications set to 3 and retention set to permenant(-1):
```bash
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic aTopic --replication-factor 3 --partitions 1 --config retention.ms=-1
```
Check the result:
```bash
kafka-topics --zookeeper smartaqnet-0-node0:22181 --describe --topic aTopic
```
The commands above can be executed on any node with kafka client programs.
Run the following cmd from host after setting up kafka containers to create Sensorthings entity topics:
```bash
docker exec -it $(docker ps -q --filter "name=kafka-env-cluster") "/etc/confluent/docker/init-topics.sh"
```

## MirrorMaker
A service that replicates data from one data center to another. To use MirrorMaker, two config files need to be defined in the machine where the service runs: __sourceClusterConsumer.config__ and __sourceClusterProducer.config__ specifiy the source data center and the target data center. Topics to be subscribed are specified with `--whitelist`. These are done with the following script(init-mirrormaker)::

```bash
#!/usr/bin/env bash
# Define source data center
docker exec $(docker ps -q --filter name=kafka) bash -c "cat >sourceClusterConsumer.config <<EOL 
bootstrap.servers=smartaqnet-0-node1.teco.edu:9092,smartaqnet-0-node2.teco.edu:9092,smartaqnet-0-node3.teco.edu:9092 
group.id=mmGroup 
exclude.internal.topics=true 
client.id=mirror_maker_consumer 
EOL"
# Define target data center
docker exec $(docker ps -q --filter name=kafka) bash -c "cat >sourceClusterProducer.config <<EOL 
bootstrap.servers=smartaqnet-dev.teco.edu:9092 
acks=1 
batch.size=100 
client.id=mmProducer 
EOL"
# Start MM
docker exec -d $(docker ps -q --filter name=kafka) bash -c "/usr/bin/kafka-run-class kafka.tools.MirrorMaker --consumer.config sourceClusterConsumer.config --producer.config sourceClusterProducer.config --num.streams 2 -whitelist=\"Things,Observations,MultiDatastreams,Locations,ObservedProperties,HistoricalLocations,FeaturesOfInterest,DataStreams,BeatsLocal\""
```
The script need to be run on the machine where a kafka container runs, so that a MirrorMaker Service can be initialized in the kafka container on that machine.