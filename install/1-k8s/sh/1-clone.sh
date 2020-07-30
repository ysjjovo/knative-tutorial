#!/bin/sh
# sh 1-clone.sh git@code.aliyun.com:lin
git_prefix=$1
base_dir=$(sh ./get_base_dir.sh)
file=$base_dir/sh/image.list
cd $base_dir/repo
while read IMAGE; do
    arr=($(echo $IMAGE | awk -F/ '{print $2}' | awk -F: '{print $1,$2}'))
    git clone $git_prefix/${arr[0]}.git
done <$file
