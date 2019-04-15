## Spring Cloud Feign配置之Ribbon、Hystrix

### 目录

### 介绍

### 1 Ribbon配置

Spring Cloud Feign的客户端负载均衡使用Spring Cloud ribbon来实现6。

**1.1** 全局配置

格式：ribbon.< key > =< value >,例如下：（主要有超时与重试，**超时后可以可以进行重试**）

	ribbon.ConnectTimeout=500
	ribbon.ReadTimeout=5000

**1.2** 指定服务配置

只需要在全局前加入具体服务名，格式：< client >ribbon.< key > =< value >；也可以在@FeignClient上设置。

	hello-service.ribbon.ConnectTimeout=500
	hello-service.ribbon.ReadTimeout=5000
	ribbon.OkToRetryOnAllOperations=true
	ribbon.MaxAutoRetriesNextServer=2
	ribbon.MaxAutoRetries=1

ribbon超时：

Hystrix超时：


### 2 Hystrix配置

### 参考：

	1 《Spring Cloud 微服务实战》 翟永超 电子工业出版社 2017.5

    参考网站：http://blog.didispace.com/Spring-Cloud基础教程/
			https://springcloud.cc
			https://springcloud.cc/spring-cloud-netflix.html