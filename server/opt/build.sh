#!/bin/bash

mkdir /data/es -p
mkdir /data/redis -p
mkdir /data/mysql -p
mkdir /data/mysql-files -p

mkdir /logs/es -p
mkdir /logs/nacos -p

mkdir /conf/mysql -p
mkdir /conf/nacos -p

chmod 777 /data/es
chmod 777 /data/redis
chmod 777 /data/mysql
chmod 777 /data/mysql-files

chmod 777 /logs/es
chmod 777 /logs/nacos

chmod 777 /conf/mysql
chmod 777 /conf/mysql/*
chmod 777 /conf/nacos
chmod 777 /conf/nacos/*
chmod 777 /conf/redis
chmod 777 /conf/redis/*
chmod 777 /conf/kibana
chmod 777 /conf/kibana/*
chmod 777 /conf/elasticsearch
chmod 777 /conf/elasticsearch/*
chmod 777 /conf/seata
chmod 777 /conf/seata/*

docker-compose -f /opt/docker-yml/server.yml up -d
