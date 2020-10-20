#!/bin/sh
#sh 7-tracing.sh 0.16.0
version=$1
base_dir=$(sh ./get_base_dir.sh)
yaml=$base_dir/target/yaml/monitor/$version/monitoring-tracing-jaeger.yaml
kubectl apply -f $yaml
