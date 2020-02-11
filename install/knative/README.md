# 简介
knative组件分三部分
- serving，核心组件
- eventing，事件相关
- monitoring，可观测性

# core安装
core包含serving和eventing,谷歌镜像无法下载，可以通过阿里云海外镜像构建新的镜像访问。步骤如下
- 从yaml文件里面提取出需要下载的镜像
- 然后生成Dockfile
- 每个Dockfile生成一个代码仓库
- 镜像服务里面关联对应Dockfile，设置构建规则自动构建

由于需要构建的镜像太多，写了几个脚本自动操作。目录结构如下：

- sh/core core相关安装脚本，按照名称顺序执行即可，3-clone.sh需要额外指定仓库名称
- sh/moitor 观测性相关安装脚本
- source 下载的原始yaml文件，按照core/monitor及版本分类
- target 从yaml生成的dockerfile及转换的yaml
```
├── sh
│   ├── core
│   └── monitor
├── source
│   ├── core
│   │   └── 0.11.0
│   └── monitor
│       └── 0.11.0
│           └── jaeger-op
└── target
    ├── dockerfile
    │   └── core
    │       └── 0.11.0
    └── yaml
        ├── core
        │   └── 0.11.0
        └── monitor
            └── 0.11.0
```