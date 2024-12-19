#!/bin/bash

declare -A jars
jars["adapter"]="/opt/jar/neighbour-resource-adapter.jar"
jars["gateway"]="/opt/jar/neighbour-resource-adapter-gateway.jar"

nacos_server="127.0.0.1:8848"
jvm_ops="-Xms512m -Xmx512m -XX:+UseParallelGC"

if [[ -v jars["$1"] ]]; then
  jar_name=${jars["$1"]}
else
  echo "没有找到与 $1 相关的jar"
  exit
fi

if [ "$1" == "adapter" ]; then
    jvm_ops="-Xms2048m -Xmx2048m -XX:+UseParallelGC"
fi

declare -A params

for arg in "$@"; do
  echo "arg $arg"
  if [[ "${arg:0:2}" == "--" ]]; then
      IFS='=' read -ra arr <<< "${arg:2}"
      if [[ ${#arr[@]} -eq 1 ]] ; then
        key=${arr[0]}
        params[$key]=$key
      else
        key=${arr[0]}
        value=${arr[1]}
        params[$key]=$value
      fi
  fi
done

port=${params['port']}
version=${params['version']}

if [[ -z "$version" ]]; then
   echo '未指定版本号程序终止. 示例--version=v1'
   exit
else
  jvm_ops="$jvm_ops -Dspring.cloud.nacos.discovery.metadata.version=$version"
fi


if [[ -n "$port" ]]; then
    if [[ $(lsof -i:"$port" | wc -l) -gt 0 ]]; then
      echo "启动失败, 端口 $port 被占用"
      exit
    fi

    jvm_ops="$jvm_ops -Dserver.port=${params['port']}"
fi

if [[ -n "${params['nacos']}" ]]; then
    nacos_server=${params['nacos']}
fi

nohup java -jar $jvm_ops -Dspring.cloud.nacos.discovery.server-addr="${nacos_server}" -Dspring.cloud.nacos.config.server-addr="${nacos_server}" \
-Dlogging.config=/opt/logback.xml $jar_name > /dev/null 2>&1 &

echo "执行 nohup java -jar $jvm_ops -Dspring.cloud.nacos.discovery.server-addr=${nacos_server} -Dspring.cloud.nacos.config.server-addr=${nacos_server} -Dlogging.config=/opt/logback.xml $jar_name > /dev/null 2>&1 &"

log_dir=${params['logs']}

if [ "$log_dir" == "logs" ]; then
  index=$(expr index "$jar_name" ".")
  log_dir=${jar_name:9:$index-10}
fi

echo "jar=$jar_name log_dir=$log_dir"

if [[ -n "$log_dir" && -f "/opt/jar/logs/$log_dir/log.log" ]]; then
  echo "开始读取日志 /opt/jar/logs/$log_dir/log.log"
  tail -f /opt/jar/logs/"$log_dir"/log.log
fi
