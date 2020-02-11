#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

source_dir=$base_dir/source/core/$version
mkdir -p $source_dir
cd $source_dir &&
    wget -N https://github.com/knative/serving/releases/download/v$version/serving.yaml &&
    wget -N https://github.com/knative/serving/releases/download/v$version/serving-cert-manager.yaml &&
    # Eventing Component:
    wget -N https://github.com/knative/eventing/releases/download/v$version/release.yaml &&
    wget -N https://github.com/knative/eventing/releases/download/v$version/eventing.yaml &&
    wget -N https://github.com/knative/eventing/releases/download/v$version/in-memory-channel.yaml &&
    #Eventing Resources:
    wget -N https://github.com/knative/eventing-contrib/releases/download/v$version/github.yaml &&
    wget -N https://github.com/knative/eventing-contrib/releases/download/v$version/camel.yaml &&
    wget -N https://github.com/knative/eventing-contrib/releases/download/v$version/kafka-source.yaml &&
    wget -N https://github.com/knative/eventing-contrib/releases/download/v$version/kafka-channel.yaml
