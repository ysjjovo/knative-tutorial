#!/bin/sh
# image_list image_dir version
# sh load.sh serving/serving.image.list 0.11.0
# sh load.sh istio/istio.image.list
dir=$(dirname $1)
while read IMAGE
do
  if [ -n "$2" ];then
    IMAGE="$IMAGE:$2"
  fi
  echo "loading $IMAGE"
  docker load < $dir/${IMAGE//\//#}.tar
  echo ok
done < $1