# activator
接收并缓存未激活请求,同时也包含刚扩容的pod，并上报请求数据给autoscaler

# autoscaler
接收请求指标并动态伸缩Pod来处理请求

# controller
保证knaitve自定义资源的一致性，例如创建一个Knative service时，由它来自动创建对应的configuration和Route,再由configuration转换成revision,deployment,KPA

# webhook
k8s api请求拦截器。负责设置默认值，拒绝不一致或无效请求

# networking-certmanager
证书配置

# networking-istio todo
支持Ingress到[istio virtual service](https://istio.io/docs/reference/config/networking/v1alpha3/virtual-service/)的转换