#!/bin/sh
# sh reset_repos.sh
base_dir=$(sh ./get_base_dir.sh)
file=$base_dir/sh/image.list
cd $base_dir/repo
while read IMAGE; do
    arr=($(echo $IMAGE | awk -F/ '{print $2}' | awk -F: '{print $1,$2}'))
    name=${arr[0]}
    version=${arr[1]}
    cd $name
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
done <$file
