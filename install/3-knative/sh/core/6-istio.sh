#!/bin/sh
#sh 6-istio.sh 0.15.0 registry.cn-chengdu.aliyuncs.com/istio-releases

version=$1
hub_prefix=$2
base_dir=$(sh ./get_base_dir.sh)

dir=$base_dir/target/yaml/core/$version

cat <<EOF >./istio-minimal-operator.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      proxy:
        autoInject: disabled
      useMCP: false
      # The third-party-jwt is not enabled on all k8s.
      # See: https://istio.io/docs/ops/best-practices/security/#configure-third-party-service-account-tokens
      jwtPolicy: first-party-jwt

  addonComponents:
    pilot:
      enabled: true
    prometheus:
      enabled: false

  components:
    ingressGateways:
      - name: istio-ingressgateway
        enabled: true
      - name: cluster-local-gateway
        enabled: true
        label:
          istio: cluster-local-gateway
          app: cluster-local-gateway
        k8s:
          service:
            type: ClusterIP
            ports:
            - port: 15020
              name: status-port
            - port: 80
              name: http2
            - port: 443
              name: https
EOF

./istioctl manifest apply -f istio-minimal-operator.yaml --set hub=$hub_prefix

kubectl apply -f $dir/release.yaml
