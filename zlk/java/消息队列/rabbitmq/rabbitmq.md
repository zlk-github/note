## 消息队列之RabbitMQ

### 常用消息队列：

Kafka在于分布式架构，RabbitMQ基于AMQP协议来实现，RocketMQ（阿里）/思路来源于kafka，改成了主从结构，在事务性可靠性方面做了优化。广泛来说，电商、金融等对事务性要求很高的，可以考虑RabbitMQ和RocketMQ，对性能要求高的可考虑Kafka。基于Apache的ActiveMQ性能最差。

### 介绍

异步数据处理，生产者将数据扔入队列，消费者去消费队列消息。将一些无需即时返回且耗时的操作提取出来，进行了异步处理，而这种异步处理的方式大大的节省了服务器的请求响应时间，从而提高了系统的吞吐量。

### 1 安装环境

安装参考：https://blog.csdn.net/xiaopu99/article/details/79109584

RabbitMQ api名词介绍查看：https://blog.csdn.net/lyhkmm/article/details/78775369#commentBox

1.安装Erlang 

2.安装RabbitMQ

sbin下

	rabbitmq-service.bat stop  
	rabbitmq-service.bat install  
	rabbitmq-service.bat start 

### 2

	