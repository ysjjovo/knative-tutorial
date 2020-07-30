#!/bin/sh
# sh pull.sh istio/istio.image.list
dir=$(dirname $1)
while read IMAGE; do
  if [ x$IMAGE == x ]; then
    break
  fi
  if [ -n "$2" ]; then
    IMAGE="$IMAGE:$2"
  fi
  echo "pulling $IMAGE"
  docker pull $IMAGE
  echo ok
done <$1
