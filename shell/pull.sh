#!/bin/bash


if [ $# -eq 1 ]; then
  echo "删除有关<$1>容器与镜像"
  docker stop $1
  docker rm $1
  docker rmi "registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_$1"
  docker-compose -f "/opt/compose/$1/$1.yml" up -d
else
  echo "删除所有容器与镜像"
  docker stop $(docker ps -qa)
  docker rm $(docker ps -qa)
  docker rmi --force $(docker images -q)
  docker-compose -f /opt/compose/server.yml up -d
fi