##  Redis

Redis由c语言开发。

### 1安装
https://blog.csdn.net/qq_30764991/article/details/81564652

1.1 安装c的编译环境
 yum install gcc-c++

1.2 安装 Redis

	   1 上传包到linux（redis下载地址http://download.redis.io/releases/redis-3.2.8.tar.gz）
	   命令：sz

	   2 解压redis-3.2.8.tar.gz
       命令：tar zxvf redis-3.2.8.tar.gz

       3 到解压后目录redis-3.2.8下进行编译。
       命令：make

       4 安装PREFIX后为redis安装目录。
       make install PREFIX=/usr/local/redis/redis-3.2.8

1.3 启动与关闭
     
进入redis的bin目录下：

	1启动：./redis-server 或者./redis-server /usr/local/redis/redis-3.2.8/redis.conf

    推荐后一种（1配置文件redis.conf中修改daemonize yes;
    2 bind 127.0.0.1改为bind 内网ip,否则只能本地访问到）
    使用Ctrl+c退出。


	2关闭： ./redis-cli shutdown

    3 查看进程： ps aux|grep redis   

	netstat -antpl | grep redis

