# 安装broker
在指定命名空间下安装，有两种方式
- 空间注解
```bash
kubectl label namespace default knative-eventing-injection=enabled
```
会自动创建default broker，使用命令查看
```bash
kubectl -n default get broker default
```
删除空间注解不会删除broker，需要手动运行命令删除
```bash
kubectl -n foo delete broker default
```
- 手动安装
运行如下脚本
```bash
# default空间下创建两个sa
kubectl -n default create serviceaccount eventing-broker-ingress
kubectl -n default create serviceaccount eventing-broker-filter
# 授权
kubectl -n default create rolebinding eventing-broker-ingress \
  --clusterrole=eventing-broker-ingress \
  --serviceaccount=default:eventing-broker-ingress
kubectl -n default create rolebinding eventing-broker-filter \
  --clusterrole=eventing-broker-filter \
  --serviceaccount=default:eventing-broker-filter
# 还需要eventing的配置读取权限,注意空间名字是否有更换
kubectl -n knative-eventing create rolebinding eventing-config-reader-default-eventing-broker-ingress \
  --clusterrole=eventing-config-reader \
  --serviceaccount=default:eventing-broker-ingress
kubectl -n knative-eventing create rolebinding eventing-config-reader-default-eventing-broker-filter \
  --clusterrole=eventing-config-reader \
  --serviceaccount=default:eventing-broker-filter
# 创建default broker
cat << EOF | kubectl apply -f -
apiVersion: eventing.knative.dev/v1alpha1
kind: Broker
metadata:
  namespace: default
  name: default
EOF
```
# 测试event
- 创建订阅关系
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-service
  namespace: default
spec:
  template:
    spec:
      containers:
      -  # This corresponds to
         # https://github.com/knative/eventing-contrib/blob/v0.2.1/cmd/message_dumper/dumper.go.
         image: gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/message_dumper@sha256:ab5391755f11a5821e7263686564b3c3cd5348522f5b31509963afb269ddcd63
```
- 创建trigger
```yaml
apiVersion: eventing.knative.dev/v1alpha1
kind: Trigger
metadata:
  name: my-service-trigger
  namespace: default
spec:
  filter:
    attributes:
      type: dev.knative.foo.bar
  subscriber:
    ref:
      apiVersion: serving.knative.dev/v1
      kind: Service
      name: my-service
```
- 手动发送事件,事件遵循http协议
```bash
curl -v "http://default-broker.default.svc.cluster.local/" \
  -X POST \
  -H "X-B3-Flags: 1" \
  -H "CE-SpecVersion: 0.2" \
  -H "CE-Type: dev.knative.foo.bar" \
  -H "CE-Time: 2018-04-05T03:56:24Z" \
  -H "CE-ID: 45a8b444-3213-4758-be3f-540bf93f85ff" \
  -H "CE-Source: dev.knative.example" \
  -H 'Content-Type: application/json' \
  -d '{ "much": "wow" }'
```

- 使用ContainerSource发送事件
```yaml
apiVersion: sources.eventing.knative.dev/v1alpha1
kind: ContainerSource
metadata:
  name: heartbeats-sender
spec:
  template:
    spec:
      containers:
        - image: github.com/knative/eventing-contrib/cmd/heartbeats/
          name: heartbeats-sender
          args:
            - --eventType=dev.knative.foo.bar
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
  sink:
    apiVersion: eventing.knative.dev/v1alpha1
    kind: Broker
    name: default
```