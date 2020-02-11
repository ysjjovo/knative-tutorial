#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

dockerfile_dir=$base_dir/target/dockerfile/core/$version
target_dir=$base_dir/..

arr=($(ls $dockerfile_dir))
# branch=release-v$version
for ((i = 0; i < ${#arr[@]}; i += 1)); do
    cd $target_dir/${arr[i]}
    git checkout master
    cp $dockerfile_dir/${arr[i]} Dockerfile
    git add .
    git commit -m $version
    git push origin master
    git tag release-v$version
    git push origin release-v$version
done