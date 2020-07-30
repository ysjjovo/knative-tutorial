#!/bin/sh
source=$1
target=$2
arr=($(docker images | grep $source | awk '{print $1":"$2}'))

for str in ${arr[@]}; do
    t=$(echo $str | sed "s#$source#$target#g")
    echo $t
    docker tag $str $t
    docker push $t
done
