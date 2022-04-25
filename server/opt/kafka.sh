#!/bin/bash

mkdir /data/zookeeper -p
mkdir /data/kafka -p

chmod 777 /data/zookeeper
chmod 777 /data/kafka

docker-compose -f /opt/docker-yml/kafka/kafka.yml up -d