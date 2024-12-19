#!/bin/bash

declare -A jars
jars["adapter"]="/opt/jar/neighbour-resource-adapter.jar"
jars["gateway"]="/opt/jar/neighbour-resource-adapter-gateway.jar"

if [[ -v jars["$1"] ]]; then
  jar_name=${jars["$1"]}
else
  echo "没有找到与 $1 相关的jar"
  exit
fi

declare -A params

for arg in "$@"; do
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

version=${params['version']}

jar_name=${jar_name:9}

if [[ -n "$version" ]]; then
  readarray -t pid_list < <(pgrep -f "java -jar.*version=$version.*$jar_name")
else
  readarray -t pid_list < <(pgrep -f "java -jar.*$jar_name")
fi

if [[ -z "${pid_list[0]}" ]]; then
  echo "没有启动 $jar_name 相关的进程"
else
  for pid in "${pid_list[@]}"; do
    echo "结束进程 $jar_name => $pid"
    kill -9 "$pid"
  done
fi