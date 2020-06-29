#!/bin/sh
# base_dir=$(sh ./get_base_dir.sh)
version=$1
base_dir=$(sh ./get_base_dir.sh)

dockerfile_dir=$base_dir/target/dockerfile/core/$version
arr=($(ls $dockerfile_dir))
cd $base_dir/target/repo
for ((i = 0; i < ${#arr[@]}; i += 1)); do
    cd ${arr[i]}
    git checkout --orphan new_branch
    git add -A
    git commit -am $version
    git branch -D master
    # git branch -D release-v$version
    # git push origin --delete release-v$version
    git branch -m master
    git push -f origin master
    git push origin --delete tag release-v$version
    cd ..
done
