#!/bin/sh
# sh 2-clone.sh 0.15.0 git@code.aliyun.com:lin
version=$1
sh 1-get.sh $version &&
    sh 2-gen.sh $version $2 &&
    sh 3-clone.sh $version $2 &&
    sh 4-push.sh $version
