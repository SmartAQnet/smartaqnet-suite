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
