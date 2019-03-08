## 3 服务容错保护：Spring Could Hystrix

### 目录

1 Hystrix搭建

2 总结

### 介绍

Spring Could Hystrix是基于Netfix的开源框架，用于解决调用故障或者延迟。Hystrix具备服务降级、服务熔断、线程和信号隔离、请求缓存、请求合并以及服务监控等强大功能。

### 1 Hystrix搭建

**1.1** pom.xml

添加spring-cloud-starter-hystrix

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<modelVersion>4.0.0</modelVersion>
		<parent>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-parent</artifactId>
			<version>2.0.1.RELEASE</version>
			<relativePath/> <!-- lookup parent from repository -->
		</parent>
		<groupId>com.example</groupId>
		<artifactId>customer</artifactId>
		<version>0.0.1-SNAPSHOT</version>
		<name>customer_server</name>
		<description>Demo project for Spring Boot</description>
	
		<properties>
			<java.version>1.8</java.version>
		</properties>
	
		<dependencies>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-web</artifactId>
			</dependency>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-test</artifactId>
				<scope>test</scope>
			</dependency>
	
			<!--euraka 服务治理-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
			</dependency>
	
			<!--ribbon 客户端负载均衡-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
			</dependency>
	
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
			</dependency>
	
			<!--hystrix容错保护-->
			<!--<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-hystrix</artifactId>
			</dependency>-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
			</dependency>
	
		</dependencies>
	
		<dependencyManagement>
			<dependencies>
				<dependency>
					<groupId>org.springframework.cloud</groupId>
					<artifactId>spring-cloud-dependencies</artifactId>
					<version>Finchley.RELEASE</version><!--spring boot 2.0 与1.0 配置时需要选择对应版本-->
					<type>pom</type>
					<scope>import</scope>
				</dependency>
				<dependency>
					<groupId>com.google.guava</groupId>
					<artifactId>guava</artifactId>
					<scope>compile</scope>
					<version>19.0</version>
				</dependency>
			</dependencies>
		</dependencyManagement>
	
		<build>
			<plugins>
				<plugin>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-maven-plugin</artifactId>
				</plugin>
			</plugins>
		</build>
	</project>

**1.2 **application.properties

	# 端口
	server.port= 8089
	# 服务名称
	spring.application.name=ribbon-customer
	
	eureka.instance.instanceId=${spring.cloud.client.ip-address}:${server.port}
	# 实例名称instanceId允许ip显示
	eureka.instance.preferIpAddress=true
	
	#将服务hello-service 注册到 http://localhost:1111/eureka/
	eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/
	
	#指明users服务的ribbon
	#users.ribbon.NFLoadBalancerRuleClassName=com.netflix.loadbalancer.WeightedResponseTimeRule

**1.3** Spring Boot启动类

@EnableCircuitBreaker注解开启断融

	/**启动类
	 * @author zhoulk
	 * @date  2019-01-03
	 */
	@EnableCircuitBreaker
	@EnableDiscoveryClient
	@SpringBootApplication
	public class CustomerApplication {
	
		@Bean
		@LoadBalanced
		RestTemplate restTemplate(){
			return new RestTemplate();
		}
		public static void main(String[] args) {
			SpringApplication.run(CustomerApplication.class, args);
		}
	}

**测试**

	1.改造UserController类login()方法，调用UserService.login();将RestTemplate实例化提到UserService类中。

	@RestController
	@RequestMapping("/user")
	public class UserController {
	
	    @Autowired
	    private UserService userService;
	
	    @RequestMapping("/login")
	    public String login()
	    {
	        //hello-service为服务提供者的服务名称
	        //return "我是一个消费者去调用==》"+restTemplate.getForEntity("http://hello-service/user/login",String.class);
	        return  userService.login();
	    }
	}

	2.类UserService实例化RestTemplate，定义一个 notFindFallback()方法返回错误提示。controller调用的login()方法加入注解 @HystrixCommand(fallbackMethod = "notFindFallback")。

	@Service("userService")
	public class UserService {
	    /**获取logger实例*/
	    private final Logger logger = Logger.getLogger(getClass().toString());
	
	    @Autowired
	    private RestTemplate restTemplate;
	
	    /**
	     *
	     * @return
	     */
	    @HystrixCommand(fallbackMethod = "notFindFallback")
	    public String login()
	    {
	        logger.info("调用：http://hello-service/user/login");
	        return "我是一个消费者去调用==》"+restTemplate.getForEntity("http://hello-service/user/login",String.class);
	    }
	
		//注：回退方法的返回类型与参数需要与目标方法一致
	    public String notFindFallback()
	    {
	        return "error";
	    }
	}
	

**注：注册中心与负载均衡配置见 "1 服务治理：Spring Could Eureka"	**

第一步：启动注册中心，端口1111

第二步：启动服务提供者，分别启动端口8888,9999

第三步：启动服务消费者，端口8089

1）调用localhost:8089/user/login,回轮流调用服务提供者端口8888,9999对应接口，并返回结果。

8888端口
![Alt text](./images/hystrix/success-8888.PNG)

9999端口
![Alt text](./images/hystrix/success-9999.PNG)

2）关闭服务提供者端口8888，调用localhost:8089/user/login。**当消费者调提供者8888，返回结果error**。当消费者调提供者8888，返回结果正常。

8888端口
![Alt text](./images/hystrix/error-8888.PNG)

9999端口
![Alt text](./images/hystrix/success-9999.PNG)

### 2 总结

Hyatrix默认的超时时间是2000毫秒。

执行回退逻辑并不代表断路器已经打开，请求失败、超时、被拒绝以及断路器打开都会执行回退逻辑。

Hystrix的隔离策略有两种：线程隔离（THREAD）和信号量隔离（SEMAPHORE），默认是THREAD。使用了@HystrixCommand来将某个函数包装成了Hystrix命令，这里除了定义服务降级之外，Hystrix框架就会自动的为这个函数实现调用的依赖隔离。


### 参考：

	1 《Spring Could 微服务实战》 翟永超 电子工业出版社 2017.5

    参考网站：http://blog.didispace.com/Spring-Cloud基础教程/
			https://springcloud.cc