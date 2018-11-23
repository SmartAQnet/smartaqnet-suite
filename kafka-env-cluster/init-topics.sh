#!/usr/bin/env bash
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic Datastreams --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic MultiDatastreams --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic FeaturesOfInterest --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic HistoricalLocations --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic Locations --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic Observations --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic ObservedProperties --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic Sensors --replication-factor 3 --partitions 1 --config retention.ms=-1
kafka-topics --zookeeper smartaqnet-0-node0:22181 --create --topic Things --replication-factor 3 --partitions 1 --config retention.ms=-1
