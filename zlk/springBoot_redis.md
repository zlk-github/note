## spring boot 整合redis做缓存

摘要：

缓存更新问题


### 1.前期工作

数据库：

	数据库名称：blog,
	创建表：CREATE TABLE `b_user` (
	          `USER_ID` int(11) NOT NULL AUTO_INCREMENT,
	          `USER_NAME` varchar(225) NOT NULL,
	          `PASSWORD` varchar(100) NOT NULL,
	          `LEVEL` varchar(100) DEFAULT NULL,
	          `PHONE` varchar(20) DEFAULT NULL,
	          `EMAIL` varchar(50) DEFAULT NULL,
	          `PROFESSIONAL` varchar(150) DEFAULT NULL,
	          `MAJOR` varchar(225) DEFAULT NULL,
	          `SCHOOL` varchar(225) DEFAULT NULL,
	          `CREATE_TIME` varchar(19) DEFAULT NULL,
	          PRIMARY KEY (`USER_ID`),
	          UNIQUE KEY `USER_NAME` (`USER_NAME`)
	        ) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

本地安装 Redis，并启动。

详见写过的文章《 Redis 安装 》http://www.bysocket.com/?p=917

### 2.搭建步骤

1.加入pom依赖（完整pom.xml附后）

	<!-- Spring Boot Reids 依赖 -->
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-redis</artifactId>
		<version>${spring-boot-starter-redis-version}</version>
	</dependency>



2.application.yml添加redis配置

	spring:
		## Redis 配置
		redis:
		   ## Redis数据库索引（默认为0）
		  database: 0
		  ## Redis服务器地址
		  host: 127.0.0.1
		  ## Redis服务器连接端口
		  port: 6379
		  ## Redis服务器连接密码（默认为空）
		  password:
		  ## 连接池最大连接数（使用负值表示没有限制）
		  pool:
		    max-active: 8
		    ## 连接池最大阻塞等待时间（使用负值表示没有限制）
		    max-wait: -1
		    ## 连接池中的最大空闲连接
		    max-idle: 8
		    ## 连接池中的最小空闲连接
		    min-idle: 0
		  ## 连接超时时间（毫秒）
		  timeout: 0
		  #以下两项正式环境需要
		  #哨兵监听redis server名称
		#  sentinel:
		#     master: mymaster
		  #哨兵的配置列表
		#  sentinel:
		#    nodes: host:port,host2:port2

3.使用StringRedisTemplate进行操作

