## Hystrix Dashboard 仪表盘踩坑


### 1 仪表盘配置后，一直ping

输入http://localhost:port/hystrix.stream页面输出一直ping.

（1）服务消费者pom.xml加入

	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-actuator</artifactId>
	</dependency>

（2）服务消费者启动类加：（hystrix-dashboard 报错 /actuator/hystrix.stream 404 Not Found）

	@Bean
	public ServletRegistrationBean hystrixMetricsStreamServlet() {
		ServletRegistrationBean registration = new ServletRegistrationBean(new HystrixMetricsStreamServlet());
		registration.addUrlMappings("/hystrix.stream");
		return registration;
	}

（3）调用一个服务接口（**该接口必须实现@HystrixCommand注解**），此时http://localhost:port/hystrix.stream页面出现数据。
