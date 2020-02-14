#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)
yaml=$base_dir/target/yaml/monitor/$version/monitoring-logs-elasticsearch.yaml

kubectl apply -f $yaml

kubectl label nodes --all beta.kubernetes.io/fluentd-ds-ready="true"
