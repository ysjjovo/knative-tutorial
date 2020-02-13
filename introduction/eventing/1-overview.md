# 设计目标
解耦事件生产者和消费者，遵循CloudEvents规范

# 消费者
事件消费者必须实现如下接口之一
- Addressable 能接收并回复事件，例如k8s service
- Callable 能接收并转换事件

# broker
接收并缓冲（持久化）事件，并且只保留满足CloudEvents规范的属性，例如：
```yaml
apiVersion: eventing.knative.dev/v1alpha1
kind: Broker
metadata:
  name: default
spec:
  channelTemplateSpec:
    apiVersion: messaging.knative.dev/v1alpha1
    kind: InMemoryChannel
```

# trigger
触发器，表示broker与事件消费者之间的订阅关系，能对只包含特定属性的事件过滤，例如：
```yaml
apiVersion: eventing.knative.dev/v1alpha1
kind: Trigger
metadata:
  name: my-service-trigger
spec:
  broker: default
  filter:
    attributes:
      type: dev.knative.foo.bar
      myextension: my-extension-value
  subscriber:
    ref:
      apiVersion: serving.knative.dev/v1
      kind: Service
      name: my-service
```
broker与trigger的关系图

![image](https://github.com/ysjjovo/knative-tutorial/raw/v0.11.0/images/broker-trigger-overview.svg)

# channel
为broker提供持久化保证，如果broker的spec.channelTemplateSpec属性未指定，则会使用该命名空间名称为default的channel。必须安装default channel,不然好像要报错,更新broker的步骤如下：
- 删除对应broker
- 重新创建同名的broker,并引用新的channel

如果直接修改broker的spec.channelTemplateSpec属性会导致broker中的事件全部丢失

