#!/bin/sh
# image_list image_dir version
# sh save.sh serving/serving.image.list 0.15.0
# sh save.sh istio/istio.image.list
dir=$(dirname $1)
while read IMAGE; do
  if [ x$IMAGE == x ]; then
    break
  fi
  if [ -n "$2" ]; then
    IMAGE="$IMAGE:$2"
  fi
  echo "saving $IMAGE"
  docker save $IMAGE | gzip >$dir/${IMAGE//\//#}.tgz
  echo ok
done <$1
