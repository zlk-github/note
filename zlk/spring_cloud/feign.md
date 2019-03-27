## 4 声明式调用：Spring Cloud Feign

### 介绍

Spring Cloud Feign基于Netfix Feign实现，整合了Spring Cloud Ribbon 和Spring Cloud Hustrix。另外还提供一种声明式的web服务客户端定义形式。简化我Spring Cloud Ribbon的封装。

### 1 Spring Cloud Feign 入门

**版本：spring boot 2.0.1+spring cloud （Finchley）**

**1.1** pom.xml

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
		<artifactId>demo</artifactId>
		<version>0.0.1-SNAPSHOT</version>
		<name>demo</name>
		<description>Demo project for Spring Boot</description>
	
		<properties>
			<java.version>1.8</java.version>
		</properties>
	
		<dependencies>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter</artifactId>
			</dependency>
	
			<!--euraka 2.0注册中心-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
			</dependency>
	
			<!--feign-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-openfeign</artifactId>
			</dependency>
	
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-test</artifactId>
				<scope>test</scope>
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

**1.2** application.properties

	# 端口
	server.port= 8089
	# 服务名称
	spring.application.name=feign-customer
	
	eureka.instance.instanceId=${spring.cloud.client.ip-address}:${server.port}
	# 实例名称instanceId允许ip显示
	eureka.instance.preferIpAddress=true
	
	#将服务hello-service 注册到 http://localhost:1111/eureka/
	eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/

**1.3** 启动类

使用@EnableFeignClients注解开启feign

	//feign
	@EnableFeignClients
	//服务发现
	@EnableDiscoveryClient
	@SpringBootApplication
	public class DemoApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(DemoApplication.class, args);
		}
	
	}

**1.4** UserService接口

定义一个接口，使用注解@FeignClient绑定服务名。

	@FeignClient("hello-service")//指定服务hello-service
	public interface UserService {
	
	    /**
	     *  hello-service服务对应接口/user/login
	     *  若有参数使用@RequestBody绑定对象，
	     *  @RequestParam或者@RequestHeader指定参数名绑定普通参数
	     */
	    @RequestMapping("/user/login")
	    public String login();
	}

**1.5** UserController类

	@RestController
	@RequestMapping("/user")
	public class UserController {
	    private Logger logger = Logger.getLogger(getClass());
	
	    @Autowired
	    private UserService userService;
	
	    @RequestMapping("login")
	    public String login(){
	        return  userService.login();
	    }
	}

**启动服务注册中心，启动两个服务名称hello-service的服务（端口8088,8087）。浏览器输入http://localhost:8089/user/login；此时将循环访问hello-service服务的8088与8087端口。实现与ribbon一致的负载均衡效果。**

验证前截图：

![Alt text](./images/feign/initial.PNG)

### 2 接口绑定

若有参数使用@RequestBody绑定对象，@RequestParam或者@RequestHeader指定参数名绑定普通参数

### 3 继承特性


### 参考：

	1 《Spring Cloud 微服务实战》 翟永超 电子工业出版社 2017.5

    参考网站：http://blog.didispace.com/Spring-Cloud基础教程/
			https://springcloud.cc
			https://springcloud.cc/spring-cloud-netflix.html