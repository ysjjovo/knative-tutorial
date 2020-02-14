#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

yaml=$base_dir/target/yaml/core/$version/serving.yaml
kubectl apply --selector knative.dev/crd-install=true -f $yaml
echo 'CRDS install completed!'
kubectl apply -f $yaml