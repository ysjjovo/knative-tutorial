# KPA
KPA全称Knative Pod Autoscaler,开箱即用，基于请求伸缩。使用如下命令查看默认配置
```bash
kubectl -n knative-serving describe cm config-autoscaler
```
默认配置如下：
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
 name: config-autoscaler
 namespace: knative-serving
data:
 # 容器并发限制，软限制
 container-concurrency-target-default: "100"
 container-concurrency-target-percentage: "0.7"
# 允许缩容至0
 enable-scale-to-zero: "true"
# 缩容至0的间隔
 scale-to-zero-grace-period: "30s"
# 稳定窗口，即在窗口期间不伸缩
 stable-window: "60s"
# 扩容速率
 max-scale-up-rate: "1000"
# 缩容速率
 max-scale-down-rate: "2"
 panic-window-percentage: "10"
 panic-threshold-percentage: "200"
 tick-interval: "2s"
 target-burst-capacity: "200"
 requests-per-second-target-default: "200"
 ```
 可以在Revision里面的annotation单独配置的有
 - stable window，最小能设置6s
 ```yaml
autoscaling.knative.dev/window: "60s"
 ```
 - 并发数
  ```yaml
 autoscaling.knative.dev/target: "50"
 ```
 需要严格限制容器并发数，则在Revison模板添加参数
 # todo
 ```yaml
 containerConcurrency: 0 | 1 | 2-N
 ```
 - 0 由系统决定
 - 1 串行化，同Openwhisk
 - 2 or more 允许并发请求数

限制伸缩边界，（容器预热）。在Revision模板里面配置minScale和maxScale，示例为预热2个容器，最多扩容10个容器
```yaml
spec:
 template:
  metadata:
   annotations:
    autoscaling.knative.dev/minScale: "2"
    autoscaling.knative.dev/maxScale: "10"
```
# HPA
HPA全称Horizontal Pod Autoscaler,可以配置基于CPU指标伸缩，如下配置示例为cpu使用率70%为伸缩阀值：
```yaml
spec:
 template:
  metadata:
   annotations:
    autoscaling.knative.dev/metric: cpu
    autoscaling.knative.dev/target: "70"
    autoscaling.knative.dev/class: hpa.autoscaling.knative.dev
Using the recommended autoscaling
```

# 自定义Autoscaler
当KPA和HPA都不满足需求时，Knative支持自定义Autoscaler，需要实现一个contoller来处理自定义的Autoscaler,这里有一个官方的controller[实现示例](https://github.com/knative/sample-controller)