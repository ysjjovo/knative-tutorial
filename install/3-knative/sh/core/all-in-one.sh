#!/bin/sh
version=$1
sh 1-get.sh $version &&\
sh 2-gen.sh $version $2 &&\
sh 3-clone.sh $version $2 &&\
sh 4-push.sh $version
