## 2 客户端负载均衡：Spring Cloud  Ribbon

### 目录

1 RestTemplate 详解

2 Ribbon配置

3 总结

### 介绍

Spring Cloud  Ribbon是一个基于HTTP和TCP的客户端负载均衡工具，基于Netfix Ribbon实现。通过Spring Cloud封装，将面向服务的REST模板请求自动转换为客户端负载均衡的服务调用。

负载均衡：按一定的算法获取服务器清单地址中的一个，进行转发。（服务消费端需要用到）

Spring Cloud  Ribbon客户端负载均衡：

1. 服务提供者启动多个服务实例并注册到注册中心（单注册中心或者高可用注册中心）；
2. 服务消费者直接调用@LoadBalanced注解修饰过的RestTemplate来实现面向服务的接口调用。

### 1 RestTemplate 详解

分别介绍GET、POST、PUT、DELETE四种不同请求类型与参数类型的服务调用实现。

1.1 GET请求

GET请求：getForEntity与getForObject函数

1.1.1 getForEntity函数

getForEntity函数，方法返回ResponseEntity,该对象是String对HTTP请求的响应封装。主要包含状态码HttpStatus,请求头HttpHeadders以及泛型类型的请求体对象。responseEntity.getBody()获取返回结果。

传参方式1：

参数在url路径上，使用@PathVariable注解告诉参数在url上。
 
	服务提供
	@GetMapping(value = "/getTest/{name}/{password}")
	    public String getTest(@PathVariable String name,@PathVariable String password){
	        logger.info("服务host:"+port+",service_id:"+hostname);
	        return "这是一个服务提供者,name："+name+";password:"+password+"";
	    }
	
	服务消费
	ResponseEntity<String> responseEntity = restTemplate.getForEntity("http://hello-service/user/getTest/{name}/{password}", String.class, "admin", "123456");
	
传参方式2：

参数在url路径后面。
 
	（1）
	服务提供
	@GetMapping(value = "/getTest")
	    public String getTest(String name, String password){
	        logger.info("服务host:"+port+",service_id:"+hostname);
	        return "这是一个服务提供者,name："+name+";password:"+password+"";
	    }
	
	服务消费
	 ResponseEntity<String> responseEntity = restTemplate.getForEntity("http://hello-service/user/getTest?name={name}&password={password}", String.class, "admin", "123456");

	（2）
    注：也可以使用下面这种方式，服务提供者需要使用@RequestParam注解接收参数

	服务消费，使用map传参
	Map<String, Object> requestMap = Maps.newHashMap();
    requestMap.put("name", "123456");
    requestMap.put("password", "xiao ming");
    ResponseEntity<String> responseEntity = restTemplate.getForEntity("http://hello-service/user/getTest?name={name}&password={password}", String.class, requestMap);

	服务提供，@RequestParam注解map接收参数。
	 @GetMapping(value = "/getTest")
	    public String getTest(@RequestParam Map<String, Object> map){
	        logger.info("服务host:"+port+",service_id:"+hostname);
	        return "这是一个服务提供者,name："+map.get("name")+";password:"+"";
	    }

传参方式：

url中无参数

	restTemplate.getForEntity("http://hello-service/user/login",String.class);

1.1.2 getForObject函数

对getForEntity函数的进一步封装，不关注body时使用。传参方式和getForEntity一致。不赘述。

1.2 POST 请求

POST请求：postForEntity与postForObject函数

传参形式与get相似，但是第二个参数与第三个参数与get相反。参数可以是自定义对象。


例：

	服务提供者：
	 @RequestMapping(value = "/postTest",method =RequestMethod.POST)
	    public String postTest(@RequestBody User user ){
	        return "这是一个服务提供者,name:"+user.getName()+";password:"+"";
	    }

	服务消费者：
	 User user = new User();
	        user.setName("admin");
	        user.setPassword("1134253");
	        ResponseEntity<String> responseEntity = restTemplate.postForEntity("http://hello-service/user/postTest", user,String.class);


1.3 PUT请求

PUT请求：put函数。方法基本与postForObject一致。

	@RequestMapping("/put")
	public void put() {
	    Book book = new Book();
	    book.setName("红楼梦");
	    restTemplate.put("http://HELLO-SERVICE/getbook3/{1}", book, 99);
	}

1.4 DELETE请求

DELETE请求：delete函数，标识在url中，可带参。

@RequestMapping("/delete")
public void delete() {
    restTemplate.delete("http://HELLO-SERVICE/getbook4/{1}", 100);
}


### 2 Ribbon配置

从版本1.2.0开始，Spring Cloud Netflix现在支持使用属性与Ribbon文档兼容来自定义Ribbon客户端。

这允许您在不同环境中更改启动时的行为。

支持的属性如下所示，应以< clientName >.ribbon.为前缀：

	NFLoadBalancerClassName：应实施ILoadBalancer（维护所有服务实例的清单，存储正常服务的实例清单）
	
	NFLoadBalancerRuleClassName：应实施IRule（负载均衡规则）
	
	NFLoadBalancerPingClassName：应实施IPing （负责检查服务实例是否存活（UP））
	
	NIWSServerListClassName：应实施ServerList （获取服务器列表的方法的接口）
	
	NIWSServerListFilterClassName应实施ServerListFilter（根据一些规则去过滤部分服务）
	
	注意
	在这些属性中定义的类优先于使用@RibbonClient(configuration=MyRibbonConfig.class)定义的bean和由Spring Cloud Netflix提供的默认值。

**参数配置的两种方式**：

第一种：全局配置
	
	ribbon.< key > = < value >
	例：ribbon.ConnectTimeout=30

第二种：指定客户端配置

	<client>.ribbon.< key > = < value >
	例：hello-service.ribbon.listOfServers = localhoat:8089,localhoat:8081

2.1 设置服务名称hello-service对应的IRule规则

	hello-service.ribbon.NFLoadBalancerRuleClassName=com.netflix.loadbalancer.WeightedResponseTimeRule

自定义重写：覆盖IRule

	//name：建议写服务名称     configuration：配置类
	//http://springCloud-ribbon-police/getPolice 调用"springCloud-ribbon-police"这个服务ID的时候，将会启用下面的配置
	@RibbonClient(name="springCloud-ribbon-police", configuration=LbConfig.class)
	public class LbConfig {
	
	    @Bean
	    public IRule getRule(){
	        return new MyRule();
	    }
	}

2.2 禁用Eureka维护服务实例

	ribbon.eureka.enableed=false
	
	指定区域:eureka.instance.metadataMap.zone=shanghai

2.3 重试机制

主要处理容错。

    #该参数用来开启重试机制，它默认是关闭的，默认false。
	spring.cloud.loadbalancer.retry.enabled=true
	
    #断路器的超时时间需要大于ribbon的超时时间，不然不会触发重试。
	hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=10000
	
    #请求连接的超时时间
	hello-service.ribbon.ConnectTimeout=250
    #请求处理的超时时间
	hello-service.ribbon.ReadTimeout=1000
	#对所有操作请求都进行重试
	hello-service.ribbon.OkToRetryOnAllOperations=true
	#切换实例的重试次数
	hello-service.ribbon.MaxAutoRetriesNextServer=2
	#对当前实例的重试次数
	hello-service.ribbon.MaxAutoRetries=1


### 总结

Spring Cloud  Ribbon结合Spring Cloud  Eureka可以完成消费者调服务提供者的负载均衡。但是同时使用，默认服务列表由Eureka维护。如果需要重定义Ribbon的一些参数，需要重写覆盖方法（如2.1中所示）。Eureka牺牲一定的一致性,故需要重试机制。

### 参考：

	1 《Spring Cloud  微服务实战》 翟永超 电子工业出版社 2017.5

    参考网站：http://blog.didispace.com/Spring-Cloud基础教程/
             https://springcloud.cc/spring-cloud-netflix.html