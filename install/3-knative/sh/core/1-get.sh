#!/bin/sh
#sh 1-get.sh 0.15.0
version=$1
base_dir=$(sh ./get_base_dir.sh)

source_dir=$base_dir/source/core/$version
mkdir -p $source_dir
cd $source_dir &&
    wget -N https://github.com/knative/serving/releases/download/v$version/serving-crds.yaml &&
    wget -N https://github.com/knative/serving/releases/download/v$version/serving-core.yaml &&
    wget -N https://github.com/knative/net-istio/releases/download/v$version/release.yaml
