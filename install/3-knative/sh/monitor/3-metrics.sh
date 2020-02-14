#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)
yaml=$base_dir/target/yaml/monitor/$version/monitoring-metrics-prometheus.yaml

kubectl apply -f $yaml