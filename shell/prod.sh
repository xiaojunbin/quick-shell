#!/bin/bash

ROOT_PATH='/opt/code/together'
REMOTE_REGISTRY_URI='registry.cn-shenzhen.aliyuncs.com';
PROFILE='prod'

# 登录docker
docker login --username=办公室小伙 --password=spider898989 $REMOTE_REGISTRY_URI
if [ $? -ne 0 ]; then
    echo "连接 $REMOTE_REGISTRY_URI 失败"
    exit
fi

echo "开始构建>> $PROFILE"
echo "项目路径>> $ROOT_PATH"

cd $ROOT_PATH
git checkout master
git branch -d $PROFILE
git checkout -b $PROFILE origin/$PROFILE
git pull
if [ $? -ne 0 ]; then
    echo "远程分支 $PROFILE 拉取失败"
    exit
fi

mvn clean package -P$PROFILE -DskipTests
# mvn clean package -Pprod -DskipTests
# mvn docker:build -Pprod

cd "$ROOT_PATH/gateway"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/user"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/shop" # merchant
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/goods"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/order"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/spell"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/sendOut" # winner
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/ReMoney" # rebate
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/shopbill" # bill
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/ad"
mvn docker:build -P$PROFILE
cd "$ROOT_PATH/admin" # manage
mvn docker:build -P$PROFILE

REMOTE_REGISTRY="$REMOTE_REGISTRY_URI/$PROFILE"

# example
# docker tag [ImageId] registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_prod:[镜像版本号]
# docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_prod:[镜像版本号]

# gateway
docker tag spider_gateway.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_gateway:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_gateway:latest

# user
docker tag spider_user.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_user:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_user:latest

# shop:merchant
docker tag spider_merchant.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_merchant:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_merchant:latest

# goods
docker tag spider_goods.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_goods:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_goods:latest

# order
docker tag spider_order.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_order:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_order:latest

# spell
docker tag spider_spell.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_spell:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_spell:latest

# sendOut:winner
docker tag spider_winner.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_winner:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_winner:latest

# ReMoney:rebate
docker tag spider_rebate.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_rebate:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_rebate:latest

# shopBill:bill
docker tag spider_bill.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_bill:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_bill:latest

# ad
docker tag spider_ad.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_ad:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_ad:latest

# admin:manage
docker tag spider_manage.prod:latest registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_manage:latest
docker push registry.cn-shenzhen.aliyuncs.com/prod_pretty_young/spider_manage:latest

# 重置
cd $ROOT_PATH
git checkout master

echo "打包结束"
