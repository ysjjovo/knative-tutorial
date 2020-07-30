#!/bin/sh
# sh 2-push.sh
base_dir=$(sh ./get_base_dir.sh)
file=$base_dir/sh/image.list
cd $base_dir/repo
while read IMAGE; do
    arr=($(echo $IMAGE | awk -F/ '{print $2}' | awk -F: '{print $1,$2}'))
    name=${arr[0]}
    version=${arr[1]}
    cd $name
    pwd
    git checkout master
    echo "FROM $IMAGE" >Dockerfile
    git add .
    git commit -m $version
    git push origin master
    git tag release-v$version
    git push origin release-v$version
    cd ..
done <$file
