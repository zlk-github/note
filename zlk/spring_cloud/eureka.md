## 服务治理：Spring Could Eureka
### 目录：

1 服务治理

2 服务注册中心搭建(管理服务，提供注册与发现)

3 注册服务提供者（提供服务）

4 高可用注册中心

5 注册服务消费者（消费服务）

6 总结

### 介绍：
Spring Could Eureka是Spring Could Netfix(核心组件)中的一部分，主要负责微服务框架的服务治理功能。注册中心主要提供注册与发现功能，服务提供者提供服务，服务消费者消费服务。其具有Spring Boot风格的自动化配置。**该节主要为服务治理的简单搭建。相关配置详情见"Eureka配置详解"。**

服务端：注册中心注解：@EnableEurekaServer

客户端：消费，提供注解：@EnableDiscoveryClient

主要环境配置：jdk1.8、maven3.3.9、Spring Boot2.0、IDEA2017

### 1 服务治理
服务治理主要分为服务注册于服务发现，是微服务架构的核心与基础。用以保证服务间的正常运行，降低维护成本。（服务多的时候尤为重要）。

**1.1** 服务注册

服务单元向注册中心登记自己提供的服务。包含主机、端口号、版本号、通信协议等。注册中心将根据服务名称分类组织服务清单，当进程启动时，注册中心会维护该清单。除此之外服务注册中心需要以心跳的方式监测服务是否可用，不可用需要从清单剔除，达到排查故障服务的效果。 --（怎么监控到，怎么剔除，缺少的服务（服务发现）怎么解决？）

	注册中心会维护该清单如：
	服务A: 192.168.0.100:8081;192.168.0.101:8082
	服务B: 192.168.0.100:8080;192.168.0.104:8082;192.168.0.100:8081


**1.2** 服务发现

在服务治理框架下，服务间调用是通过服务名发起调用请求。如服务A：192.168.0.100:8081,192.168.0.101:8082位置可用。当调用服务 A时将采取轮询调用（需要负载均衡）。**但是为了性能等，不会采用每次都向服务注册中心获取服务的方式。**


### 2 服务注册中心搭建

作用：该注册中心用于管理服务提供者的基本运行状况。注册中心重启，维护的服务表将清空。

主要环境配置：jdk1.8、maven3.3.9、Spring Boot 2.0

**2.1** pom.xml

添加spring-cloud-starter-netflix-eureka-server

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
				<artifactId>spring-boot-starter-web</artifactId>
			</dependency>
			<dependency>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-test</artifactId>
				<scope>test</scope>
			</dependency>
			<!--euraka 2.0注册中心-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
			</dependency>
		</dependencies>
	
		<!--@EnableEurekaServer注解报错的一种解决方式-->
		<!--<repositories>
			<repository>
				<id>spring-snapshots</id>
				<name>Spring Snapshots</name>
				<url>https://repo.spring.io/snapshot</url>
				<snapshots>
					<enabled>true</enabled>
				</snapshots>
			</repository>
			<repository>
				<id>spring-milestones</id>
				<name>Spring Milestones</name>
				<url>https://repo.spring.io/milestone</url>
				<snapshots>
					<enabled>false</enabled>
				</snapshots>
			</repository>
		</repositories>
	    -->
	    <dependencyManagement>
			<dependencies>
				<dependency>
					<groupId>org.springframework.cloud</groupId>
					<artifactId>spring-cloud-dependencies</artifactId>
					<version>Finchley.BUILD-SNAPSHOT</version><!--spring boot 2.0 与1.0 配置时需要选择对应版本-->
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

**2.2** application.properties

	#端口
	server.port= 1111
	#项目名称
	#server.servlet.context-path=/eureka11
	
    #ip 注册中心ip地址
	eureka.instance.hostname=localhost 
	# 不向注册中心注册自己,,默认true
	eureka.client.registerWithEureka=false
	# 注册中心不需要检索服务，职责是维护服务是维护实例,默认true
	eureka.client.fetchRegistry=false
	eureka.instance.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
	#本地关闭自我保护机制进行测试，默认true（未关闭）
	eureka.server.enableSelfPreservation=false

**2.3** Spring Boot启动类

使用@EnableEurekaServer注解开启注册服务中心。

	@SpringBootApplication
	@EnableEurekaServer 
	public class EurekaApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(EurekaApplication.class, args);
			System.out.println("args = [" + args + "]");
		}
	
	}

配置完成后，启动EurekaApplication类main()方法。浏览器输入http://localhost:1111/，结果如下图。
Instances currently registered with Eureka栏无数据。如下图：
![Alt text](/images/eureka/201901031013.PNG)

### 3 注册服务提供者

搭建服务，并将服务注册当上面创建的注册中心中。让注册中心统一管理服务。**当服务在请求时，该服务会注册到注册中心，但是服务死亡时，注册中心并不是马上不知道，**
Eureka server和client之间每隔30秒会进行一次心跳通信，告诉server，client还活着。由此引出两个名词： 

Renews threshold：server期望在每分钟中收到的心跳次数 

Renews (last min)：上一分钟内收到的心跳次数。

**3.1** pom.xml （pom.xml与2.1中xml相同）
 
**3.2** application.properties

将服务注册到上面的注册中心 http://localhost:8888/eureka/

	# 端口
	server.port= 8888

	# 服务名称
	spring.application.name=hello-service
	#将服务hello-service 注册到 http://localhost:1111/eureka/
	eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/

**3.3** Spring Boot启动类

    @EnableDiscoveryClient
	@SpringBootApplication
	public class ProvideApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(ProvideApplication.class, args);
			System.out.println("args = [" + args + "]");
		}
	
	}

测试接口

	@RestController
	@RequestMapping("/user")
	public class UserController {
	    /**获取logger实例*/
	    private final Logger logger = Logger.getLogger(getClass().toString());
	
	    @Value("${server.port}")
	    private String port;
	
	    @Value("${spring.application.name}")
	    private String hostname;
	
	    @RequestMapping("/login")
	    public String login(){
	        logger.info("服务host:"+port+",service_id:"+hostname);
	        return 服务host:"+port+",service_id:"+hostname;
	    }
	}

配置完成后，启动DemoApplication类main()方法。浏览器输入http://localhost:8888/user/login，请求完成后，出现"这是一个服务提供者！"。

刷新注册中心http://localhost:1111/ ；
Instances currently registered with Eureka栏出现数据。如下图：
![Alt text](/images/eureka/201901131538.PNG)

**此时如果关闭服务hello-service，注册中心显示服务还存在。当心跳时间达到时，加入自我保护模式，说明此时有服务挂掉。如下图：**
![Alt text](/images/eureka/201901031549.PNG)

### 4 高可用注册中心
将注册中心相互注册，它既是注册中心，也是服务提供者。考虑发生故障时。主要实现：
 application-peer1.properties ：注册中心peer1的serviceUr2

    # 服务名称
	spring.application.name=eureka-service
	#端口
	server.port= 1111

    #ip 注册中心ip地址
    eureka.instance.hostname=peer1 
	eureka.client.serviceUrl.defaultZone=http://peer2:2222/eureka/

 application-peer2.properties注册中心peer2的serviceUr1

    # 服务名称
	spring.application.name=eureka-service
	#端口
	server.port= 2222

    #ip 注册中心ip地址=主机名称
    eureka.instance.hostname=peer2 
	eureka.client.serviceUrl.defaultZone=http://peer1:1111/eureka/

 application.properties

	# 服务名称
	spring.application.name=eureka-service

	eureka.client.serviceUrl.defaultZone=http://peer1:1111/eureka/;
	http://peer2:2222/eureka/

 /etc/hosts 加入

	 127.0.0.1  peer1
	 127.0.0.1  peer2

启动：java -jar eureka-server-1.0.0.jar --spring.profiles-active=peer1(或者peer2)

**注：peer1、peer2为主机名称，可以直接使用主机ip。需要配置参数eureka.instance.preferIpAddressTrue=true,默认为flase。**

### 5 服务消费者（服务发现与消费）

**服务消费前准备：**启动注册中心，启动服务提供（端口8888，端口8800），
 
 启动命令：java -jar demo-0.0.1-SNAPSHOT.jar --server.port=8888 (或者8800)

 服务消费者：服务发现由Eureka的客户端完成，服务消费的任务由Ribbon（http和tcp的客户端负载均衡器）完成，

 接下来创建服务消费者：

**5.1** pom.xml

添加：spring-cloud-starter-netflix-eureka-server；spring-cloud-starter-netflix-ribbon

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
	
			<!--euraka 2.0注册客户端-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
			</dependency>
	
			<!--ribbon 用于服务消费-->
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
			</dependency>
	
		</dependencies>
	
		<dependencyManagement>
			<dependencies>
				<dependency>
					<groupId>org.springframework.cloud</groupId>
					<artifactId>spring-cloud-dependencies</artifactId>
					<version>Finchley.BUILD-SNAPSHOT</version><!--spring boot 2.0 与1.0 配置时需要选择对应版本-->
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


**5.2** application.properties

	# 端口
	server.port= 8089
	
	# 服务名称
	spring.application.name=ribbon-customer
	
	#将服务hello-service 注册到 http://localhost:1111/eureka/
	eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/

**5.3** Spring Boot启动类

配置RestTemplate，注解@EnableDiscoveryClient   

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

**测试类：**

	@RestController
	@RequestMapping("/user")
	public class UserController {
	
	    @Autowired
	    private RestTemplate restTemplate;
	
	    @RequestMapping("/login")
	    public String login()
	    {
	        //hello-service为服务提供者的服务名称
	        return "我是一个消费者去调用==》"+restTemplate.getForEntity("http://hello-service/user/login",String.class);
	    }
	}

启动后，进入测试。
注册中心显示如下图：
![Alt text](/images/eureka/201901071036.PNG)

测试接口输入：http://localhost:8089/user/login。结果将轮番调用hello-service服务的8888与8800端口。

### 6 总结
1. 服务统一交由注册中管理：eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/

2. 消费者调用服务时，直接调用服务名称。spring.application.name=ribbon-customer

### 参考：

	1 《Spring Could 微服务实战》 翟永超 电子工业出版社 2017.5

    参考网站：http://blog.didispace.com/Spring-Cloud基础教程/
###  源码地址：

https://github.com/zlk19921105/spring_cloud

其中：注册中心eureka-server;服务提供provide-services；服务消费customer-server