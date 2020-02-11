#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

source_dir=$base_dir/source/monitor/$version

yaml_dir=$base_dir/target/yaml/monitor/$version
mkdir -p $yaml_dir

cd $source_dir

arr=($(ls))

for ((i = 0; i < ${#arr[@]}; i += 1)); do
    # gen yaml file
    echo ${arr[i]}
    sed s#docker.elastic.co/kibana/##g ${arr[i]} | sed s#docker.io/##g | sed s#k8s.gcr.io#gcr.azk8s.cn/google-containers#g | sed s#quay.io#quay.azk8s.cn#g >$yaml_dir/${arr[i]}
done