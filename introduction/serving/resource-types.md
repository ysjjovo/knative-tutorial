knative自定义了一套资源（CRDs）

# Configuration
包含分离的代码和配置，对它做任何更改都会产生新的版本
示例：
```yaml
apiVersion: serving.knative.dev/v1
kind: Configuration
metadata:
  name: telemetrysample-configuration
  namespace: default
  labels:
    app: telemetrysample
spec:
  template:
    metadata:
      labels:
        knative.dev/type: app
    spec:
      containers:
      - # This is the Go import path for the binary to containerize
        # and substitute here.
        image: github.com/knative/docs/docs/serving/samples/telemetry-go
```

# Revision
示例：
Configuation的快照，历史版本，是不可修改的
```yaml
apiVersion: serving.knative.dev/v1
kind: Route
metadata:
  name: telemetrysample-route
  namespace: default
spec:
  traffic:
  - configurationName: telemetrysample-configuration
    percent: 100
```
# Service
能自动管理knative负载生命周期,对Service的任何修改都会自动更新Configuration,Revision
示例：
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: stock-service-example
  namespace: default
spec:
  template:
    metadata:
      name: stock-service-example-second
    spec:
      containers:
      - image: ${REPO}/rest-api-go
        env:
          - name: RESOURCE
            value: share
        readinessProbe:
          httpGet:
            path: /
          initialDelaySeconds: 0
          periodSeconds: 3
  traffic:
  - tag: current
    revisionName: stock-service-example-first
    percent: 50
  - tag: candidate
    revisionName: stock-service-example-second
    percent: 50
  - tag: latest
    latestRevision: true
    percent: 0
```

# Route
示例：
```yaml
apiVersion: serving.knative.dev/v1
kind: Route
metadata:
  name: telemetrysample-route
  namespace: default
spec:
  traffic:
  - configurationName: telemetrysample-configuration
    percent: 100
```