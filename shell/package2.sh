#!/bin/bash

PRJ_PATH='/root/bandex/code/bandex_exchange'
REMOTE_REGISTRY='registry.cn-shenzhen.aliyuncs.com'

# 登录docker
docker login --username=绿蚁网络 -p lvyii@go $REMOTE_REGISTRY
if [ $? -ne 0 ]; then
    echo "登录docker失败，请检查网络"
    exit
fi
PROFILE="cdev"
SNAPSHOT=""
if [ $# -eq 1 ]; then
  VERSION=$1
  SNAPSHOT=-SNAPSHOT
elif [ $# -eq 2 ]; then
  PRJ_PATH=$1
  VERSION=$2
  SNAPSHOT=-SNAPSHOT
elif [ $# -eq 3 ]; then
  PRJ_PATH=$1
  VERSION=$2
  if [ $3 -eq 1 ]; then
    SNAPSHOT=-SNAPSHOT
  fi
else
  echo "参数错误"
  exit
fi
echo "开始构建$PROFILE"
echo "项目目录为：$PRJ_PATH"

cd $PRJ_PATH

git checkout master
git pull
if [ $? -ne 0 ]; then
    echo "无法拉取远端代码"
    exit
fi
git branch -d $VERSION
git checkout -b $VERSION origin/$VERSION
if [ $? -ne 0 ]; then
    git checkout $VERSION
    if [ $? -ne 0 ]; then
        echo "切换代码分支失败，请确认远程分支存在"
        exit
    fi
fi
git pull origin $VERSION
if [ $? -ne 0 ]; then
    echo "无法拉取远端代码"
    exit
fi

echo '开始本地打包'

mvn clean package -P$PROFILE -DskipTests

cd exchange_service
mvn docker:build
cd ../exchange_trade
mvn docker:build
cd ../pusher
mvn docker:build

REMOTE_REP="$REMOTE_REGISTRY/bandex_$PROFILE"
echo $REMOTE_REP

# 生成docker tag并推送到远端
docker tag exchange_service/bandex.exchange:$VERSION$SNAPSHOT $REMOTE_REP/exchange_service:$VERSION$SNAPSHOT
docker push $REMOTE_REP/exchange_service:$VERSION$SNAPSHOT
docker tag trade/bandex.exchange:$VERSION$SNAPSHOT $REMOTE_REP/trade:$VERSION$SNAPSHOT
docker push $REMOTE_REP/trade:$VERSION$SNAPSHOT
docker tag kline_pusher/bandex.exchange:$VERSION$SNAPSHOT $REMOTE_REP/kline_pusher:$VERSION$SNAPSHOT
docker push $REMOTE_REP/kline_pusher:$VERSION$SNAPSHOT

# 回到工程目录并将分支设置为master
cd $PRJ_PATH
git checkout master

echo "执行完毕"
