#!/bin/sh
# sh 3-clone.sh 0.15.0 git@code.aliyun.com:lin
version=$1
git_prefix=$2
base_dir=$(sh ./get_base_dir.sh)
repo_dir=$base_dir/target/repo
mkdir -p $repo_dir
cd $repo_dir
dockerfile_dir=$base_dir/target/dockerfile/core/$version
arr=($(ls $dockerfile_dir))

for ((i = 0; i < ${#arr[@]}; i += 1)); do
    git clone $git_prefix/${arr[i]}.git
done
