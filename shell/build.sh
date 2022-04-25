#!/bin/bash -il
# 远程仓库地址
REMOTE_REGISTRY='registry.cn-shenzhen.aliyuncs.com'
# 环境变量
PROFILE="cdev"
# 是否快照参数
SNAPSHOT=-SNAPSHOT
# 版本号
VERSION=2.2.0
cd $WORKSPACE/

# 登录docker
docker login --username=绿蚁网络 -p lvyii@go $REMOTE_REGISTRY

echo '开始本地打包'
# mvn打包生成jar包
mvn clean package -P$PROFILE -DskipTests
cd cms_service
mvn docker:build


REMOTE_REP="$REMOTE_REGISTRY/bandex_$PROFILE"
echo $REMOTE_REP
echo BRANCH_NAME$BRANCH_NAME   

# 生成docker tag并推送到远端
docker tag cms_service/bandex.cms:$VERSION$SNAPSHOT $REMOTE_REP/cms:$VERSION$SNAPSHOT
docker push $REMOTE_REP/cms:$VERSION$SNAPSHOT
docker tag cms_service/bandex.cms:$VERSION$SNAPSHOT $REMOTE_REP/cms:latest
docker push $REMOTE_REP/cms:latest



#执行rancher更新服务api
pwd
/usr/local/bin/kubectl --kubeconfig ~/.kube/config.cdev replace --force -f src/main/resources/cdev/cms.yaml