## Spring Could Eureka配置详解

### 目录
1 instance：当前Eureka Instance实例信息配置

2 client：Eureka Client客户端特性配置

3 server：Eureka Server注册中心特性配置

4 dashboard：Eureka Server注册中心仪表盘配置

5 Spring Could Eureka常用配置清单

### 介绍

### Eureka包含四个部分的配置

instance：当前Eureka Instance实例信息配置；
client：Eureka Client客户端特性配置；
server：Eureka Server注册中心特性配置；
dashboard：Eureka Server注册中心仪表盘配置。

### 1 Eureka Instance实例信息配置
Bean类：org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean进行加载。包装成com.netflix.appinfo.InstanceInfo对象发送的Eureka服务端。

开头：eureka.instance

1.1 元数据
 
Eureka客户端在想服务注册中心发送注册请求时的自身服务信息描述对象。主要包含服务名称、实例名称、实例IP、实例端口等，以及一些负载均衡策略或者自定义其他特殊用途元素信息。

格式：eureka.instance.metadatamap.< key >=< value >    

如：eureka.instance.metadatamap.zone = shanghai

1.2 实例名称配置

用于区分同一服务中不同实例的标识。（即服务名称相同，主机或者端口不同），避免启动时选择端口的麻烦。   

如：eureka.instance.instanceId=${spring.application.name}:${random.int}   

1.3 端点配置

在InstanceInfo中，可以看到一些URL的配置信息，比如homePageUrl、statusPageUrl、healthCheckUrl。它们分别代表了应用主页的URL、状态页的URL、健康检查的URL。其中，状态页和监控检查的URL在Spring Cloud Eureka中默认使用了spring-boot-actuator模块提供的/info端点和/health端点。为了服务的正常运作，必须确认Eureka客户端的/health端点在发送元数据的时候，是一个能够被注册中心访问的地址，否则服务注册中心不会根据应用的健康状态来更改状态（仅当开启了healthcheck功能时，以该端点信息作为健康检查标准）。而/info端点如果不正确的话，会导致在Eureka面板单击服务实例时，无法访问到服务实例提供的信息接口。

在一些特殊的情况下，**比如，为应用设置了context-path，**这时，所有spring-boot-actuator模块的监控端点都会增加一个前缀。所以，我们就需要做类似如下的配置，为/info和/health端点也加上类似的前缀：

	management.context-path=/hello
	eureka.instance.statusPageUrlPath=${management.context-path}/info
	eureka.instance.healthCheckUrlPath=${management.context-path}/health
另外，有时候为了安全考虑，也有可能会修改/info和/health端点的原始路径。这个时候，我们也需要做一些特殊配置，例如：

	endpoints.info.pah=/appinfo
	endpoints.health.path=/cheakHealth
	eureka.instance.statusPageUrlPath=/${endpoints.info.pah}
	eureka.instance.healthCheckUrlPath=/${endpoints.health.path}
上面实例使用的是相对路径。

由于Eureka的服务注册中心默认会以HTTP的方式来访问和暴露这些端点，因此当客户端应用以HTTPS的方式来暴露服务和监控端点时，相对路径的配置方式就无法满足要求了。所以，Spring Cloud Eureka还提供了绝对路径的配置参数，例如：

	eureka.instance.homePageUrl=https://${eureka.instance.homename}
	eureka.instance.statusPageUrlPath=https://${eureka.instance.homename}/info
	eureka.instance.healthCheckUrlPath=https://${eureka.instance.homename}/health

1.4 健康检测

 **默认情况下，Eureka中各个服务实例的健康检查并不是通过spring-boot-actuator模块的/health端点来实现的，而是依靠客户端心跳的方式保持服务实例的存活**，在Eureka的服务续约与剔除机制下，客户端的监控状态从注册到注册中心开始都会处于UP状态，除非心跳终止一段时间之后，服务注册中心将其剔除。默认的心跳实现方式可以有效检查客户端进程是否正常运作，但却无法保证客户端应用能够正常提供服务。由于大多数的应用都会有一些其他的外部资源依赖，比如数据库。缓存、消息代理等，如果应用与这些外部资源无法联通的时候，实际上已经不能提供正常的对外服务了，但此时心跳依然正常，所以它还是会被服务消费者调用，而这样的调用实际上并不能获得预期的结果。

在Spring Cloud Eureka中，我们可以通过简单的配置，把Eureka客户端的监控检查交给spring-boot-actuator模块的/health端点，以实现更加全面的健康状态维护。

详细步骤如下：
	
	1 在pom.xml中加入spring-boot-starter-actuator模块的依赖。
	
	2 在application.properties中增加参数配置eureka.client.healthcheck.enabled=true
    
    3如果客户端/health端点做了特殊处理，需要参照1.3中的端点配置。

1.5 其他配置

其他配置附于后面的表清单中。
                                   
### 2 Eureka Client客户端特性配置

Eureka Client客户端特性配置是对作为Eureka客户端的特性配置，包括Eureka注册中心，本身也是一个Eureka Client。

Eureka Client特性配置全部在org.springframework.cloud.netflix.eureka.EurekaClientConfigBean中，实际上它是com.netflix.discovery.EurekaClientConfig的实现类，替代了netxflix的默认实现。

开头：eureka.client 
 

### 3 server：Eureka Server注册中心特性配置

Eureka Server注册中心端的配置是对注册中心的特性配置。Eureka Server的配置全部在org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean里，实际上它是com.netflix.eureka.EurekaServerConfig的实现类，替代了netflix的默认实现。

Eureka Server的配置全部以eureka.server.xxx的格式进行配置。

### 4 Eureka Server注册中心仪表盘配置

注册中心仪表盘的配置主要是控制注册中心的可视化展示。以eureka.dashboard.xxx的格式配置。 

### 5 Spring Could Eureka常用配置清单 
             
清单来源：https://www.cnblogs.com/li3807/p/7282492.html（致谢）  

                                                                                          