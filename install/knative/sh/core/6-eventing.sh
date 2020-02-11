#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

cd $base_dir/target/yaml/core/$version
kubectl apply --selector knative.dev/crd-install=true -f eventing.yaml
kubectl apply --selector knative.dev/crd-install=true -f in-memory-channel.yaml
echo 'CRDS install completed!'
kubectl apply -f eventing.yaml
kubectl apply -f in-memory-channel.yaml
