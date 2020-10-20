#!/bin/sh
#sh 1-get.sh 0.16.0
version=$1
base_dir=$(sh ./get_base_dir.sh)

source_dir=$base_dir/source/monitor/$version
mkdir -p $source_dir
cd $source_dir &&
    #Observability Plugins:
    wget -N https://github.com/knative/serving/releases/download/v$version/monitoring-core.yaml &&
    wget -N https://github.com/knative/serving/releases/download/v$version/monitoring-metrics-prometheus.yaml &&
    wget -N https://github.com/knative/serving/releases/download/v$version/monitoring-logs-elasticsearch.yaml &&
    wget -N https://github.com/knative/serving/releases/download/v$version/monitoring-tracing-jaeger.yaml
