#!/bin/sh
version=$1
base_dir=$(sh ./get_base_dir.sh)

source_dir=$base_dir/source/monitor/$version/jaeger-op
mkdir -p $source_dir
cd $source_dir &&
wget -N https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/crds/jaegertracing.io_jaegers_crd.yaml &&\
wget -N https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/service_account.yaml &&\
wget -N https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role.yaml &&\
wget -N https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role_binding.yaml &&\
wget -N https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/operator.yaml &&\
kubectl apply -f jaegertracing.io_jaegers_crd.yaml &&\
kubectl create namespace observability &&\
kubectl apply -f service_account.yaml &&\
kubectl apply -f role.yaml &&\ 
kubectl apply -f role_binding.yaml &&\ 
kubectl apply -f operator.yaml