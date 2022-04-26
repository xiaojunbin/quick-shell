REMOTE_REGISTRY='registry.cn-shenzhen.aliyuncs.com'
cd /root/bandex/ybt
rm -rf ybt
git clone git@gitlab.lvyii.com:yibiaotong/ybt.git
cd /root/bandex/ybt/ybt
mvn deploy
cd /root/bandex/ybt/ybt/ybt-main/
echo "开始本地打包"
mvn clean package -Pcdev -DskipTests;
mvn docker:build;

REMOTE_REP="$REMOTE_REGISTRY/bandex_cdev"
docker login --username=${username} -p ${password} $REMOTE_REGISTRY;
docker tag ybt-server/com.ybt:0.0.1-SNAPSHOT $REMOTE_REP/ybt-server/com.ybt:0.0.1-SNAPSHOT
docker push $REMOTE_REP/ybt-server/com.ybt:0.0.1-SNAPSHOT