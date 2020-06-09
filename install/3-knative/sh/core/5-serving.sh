#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

dir=$base_dir/target/yaml/core/$version
kubectl apply -f $dir/serving-crds.yaml
kubectl apply -f $dir/serving-core.yaml
