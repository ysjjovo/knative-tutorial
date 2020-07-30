#!/bin/sh
# sh 2-clone.sh 0.15.0 git@code.aliyun.com:lin
version=0.15.0
repo=git@code.aliyun.com:lin
registry=registry.cn-chengdu.aliyuncs.com/kn-release
istio_registry=registry.cn-chengdu.aliyuncs.com/istio-releases
sh 1-get.sh $version &&
    sh 2-gen.sh $version $registry &&
    sh 3-clone.sh $version $repo &&
    sh 4-push.sh $version &&
    sh 5-serving.sh $version &&
    sh 6-istio.sh $version $istio_registry
