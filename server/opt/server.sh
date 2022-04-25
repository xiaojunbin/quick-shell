#!/bin/bash

mkdir /data/es -p
mkdir /data/redis -p
mkdir /data/mysql -p
mkdir /data/mysql-files -p

mkdir /logs/es -p
mkdir /logs/nacos -p

mkdir /conf/mysql -p
mkdir /conf/nacos -p

chown -R 997:994 /data/es
chown -R 997:994 /data/redis
chown -R 997:994 /data/mysql
chown -R 997:994 /data/mysql-files

chown -R 997:994 /conf/seata
chown -R 997:994 /conf/elasticsearch.yml
chown -R 997:994 /conf/kibana.test.yml
chown -R 997:994 /conf/kibana.yml
chown -R 997:994 /conf/redis.conf
chown -R 997:994 /conf/nacos.properties
chown -R 997:994 /conf/mysql
chown -R 997:994 /conf/mysql/mysql.cnf
chown -R 997:994 /conf/nacos

chown -R 997:994 /logs/es
chown -R 997:994 /logs/nacos

docker-compose -f /opt/docker-yml/server.yml up -d
