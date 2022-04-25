#!/bin/bash

mkdir /data/es01 -p
mkdir /data/es02 -p
mkdir /data/es03 -p

chmod 777 /data/es01
chmod 777 /data/es02
chmod 777 /data/es03

docker-compose -f /opt/docker-yml/es-cluster/es-cluster.yml up -d