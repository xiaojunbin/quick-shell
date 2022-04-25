#!/bin/bash

PARAMS=($@)
param_len=${#PARAMS[@]}
IMAGES=('gateway' 'user' 'merchant' 'goods' 'order' 'spell' 'winner' 'rebate' 'bill' 'ad' 'manage' 'notify' 'manual')

if [ $param_len -gt 0 ]; then
 for image in ${PARAMS[@]} ; do
    docker stop $image;
  done
else
  for image in ${IMAGES[@]}
  do
    docker stop $image;
  done

  OLD_IMAGES=`docker images|grep spider|awk '{print $1}'`
  for image in ${OLD_IMAGES[@]}
  do
    docker rmi $image -f;
  done
fi

NONE_IMAGES=`docker images|grep none|awk '{print $3}'`
for image in ${NONE_IMAGES[@]}
do
  docker rmi $image;
done