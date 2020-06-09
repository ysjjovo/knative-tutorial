#!/bin/sh
# sh 2-gen.sh 0.15.0 registry.cn-chengdu.aliyuncs.com/ysjjovo
version=$1
base_dir=$(sh ./get_base_dir.sh)
repo_prefix=${2//\//\\/}

dockerfile_dir=$base_dir/target/dockerfile/core/$version
yaml_dir=$base_dir/target/yaml/core/$version
source_dir=$base_dir/source/core/$version
mkdir -p $dockerfile_dir $yaml_dir

cd $source_dir

arr=($(ls))
# echo $arr
\rm -f templete.sed
for ((i = 0; i < ${#arr[@]}; i += 1)); do
    # get uniq image from yaml
    images=($(sed -n 's#.*gcr.io/knative-releases/knative.dev/\(.*\)#\1#p' ${arr[i]} | sort -u))
    for ((j = 0; j < ${#images[@]}; j += 1)); do
        prefix=$(echo ${images[j]} | awk -F @ '{print $1}')
        # gen dockerfile
        origin=gcr.io/knative-releases/knative.dev/${images[j]}
        target_name=${prefix//\//-}
        cat >$dockerfile_dir/$target_name <<EOF
FROM ${origin}
EOF
        converted=${origin//\//\\/}
        echo 's/'$converted'/'$repo_prefix'\/'$target_name:$version'/g' >>templete.sed
    done
done

for ((i = 0; i < ${#arr[@]}; i += 1)); do
    # gen yaml file
    sed -f templete.sed ${arr[i]} >$yaml_dir/${arr[i]}
done
