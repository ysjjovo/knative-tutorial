# 简介
knative组件分三部分
- serving，核心组件
- eventing，事件相关
- monitoring，可观测性

# core安装
core包含serving和eventing,谷歌镜像无法下载，可以通过阿里云海外镜像构建新的镜像访问。步骤如下：
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
先运行第1，2步下载并生成Dockefile及yaml。
```bash
version=0.15.0
hub_prefix='registry.cn-chengdu.aliyuncs.com/kn-release'
sh 1-get.sh $version &&\
sh 2-gen.sh $version $hub_prefix
```
第3步clone仓库需要事先创建好对应的仓库，在target/dockerfile/core/0.11.0目录下会生成对应的Dockefile这里以eventing-cmd-apiserver_receive_adapter为例。
- 使用阿里云镜像服务创建名为knative-release的命名空间
- 在github上创建名为eventing-cmd-apiserver_receive_adapter的仓库,命名空间选择knative-release
- 下一步代码源选择github,选择创建的仓库,勾选海外构建,点创建镜像仓库

每当有新代码推送，镜像服务会自动根据对应分支构建对应版本的镜像。

重复操作第2，3步将所有对应的仓库全部创建好。

再运行后面所有的步骤完成knative的核心安装，包括clone、push所有的仓库，serving,istio的安装,注意istioctl需要先下载好放在6-istio.sh同级目录下。
```bash
version=0.15.0
git_prefix='git@code.aliyun.com:lin'
hub_prefix='registry.cn-chengdu.aliyuncs.com/istio-releases'
sh 3-clone.sh $version $git_prefix &&\
sh 4-push.sh $version &&\
sh 5-serving.sh $version &&\
sh 6-istio.sh $version $hub_prefix
```
