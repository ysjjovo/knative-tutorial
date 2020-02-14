#!/bin/sh
version=$1
repo=$2
base_dir=$(sh ./get_base_dir.sh)

dockerfile_dir=$base_dir/target/dockerfile/core/$version
arr=($(ls $dockerfile_dir))
cd $base_dir/..

for ((i = 0; i < ${#arr[@]}; i += 1)); do
    git clone $repo/${arr[i]}.git
done
