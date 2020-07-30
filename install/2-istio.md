# istio安装
运行如下脚本,需要科学上网
```bash
# Download and unpack Istio
export ISTIO_VERSION=1.4.3
curl -L https://git.io/getLatestIstio | sh -
cd istio-${ISTIO_VERSION}/bin

cat << EOF > ./istio-minimal-operator.yaml
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

./istioctl manifest apply -f istio-minimal-operator.yaml --set hub=registry.cn-chengdu.aliyuncs.com/istio-releases

# 检查pod是否都是Running状态
kubectl get pods --namespace istio-system
```