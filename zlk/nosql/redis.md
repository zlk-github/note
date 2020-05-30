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
     
进入redis的bin目录下：（**为了启动方便可以把配置文件拷到bin下**）

	1启动：./redis-server 或者./redis-server redis.conf

    推荐后一种（1配置文件redis.conf中修改daemonize yes;
    2 bind 127.0.0.1改为bind 内网ip,否则只能本地访问到）
    使用Ctrl+c退出。


	2关闭： ./redis-cli shutdown

    3 查看进程： ps aux|grep redis   

	netstat -antpl | grep redis


### 2 配置主从

123456位密码
   
2.1 配置

	1. 主服务器写入，从服务器可以读取到 
	2. 从服务器不能写入

    目录分别为：/usr/local/redis/redis-6379；/usr/local/redis/redis-6378；/usr/local/redis/redis-6377

    master的redis.conf文件
	1 port 6379
	2 daemonize yes
	3 # 这个文件夹要改成自己的目录
	4 dir "/usr/local/redis/redis-6379"
	5 # master服务器ip
    6 bind 内网ip
    7 requirepass 123456
    8 masterauth  123456

	slaver1的redis.conf文件
	1 port 6378
	2 # 主服务器端口为6379
	3 slaveof 内网ip 6379
	4 dir "/usr/local/redis/redis-6378"
    5 # slaver1服务器ip
    6 bind 内网ip
    7 requirepass 123456
    8 masterauth  123456
	
    slaver2的redis.conf文件
	1 port 6377
	2 # 主服务器端口为6379
	3 slaveof 内网ip 6379
	4 dir "/usr/local/redis/redis-6377"
    5 # slaver2服务器ip
    6 bind 内网ip
    7 requirepass 123456
    8 masterauth  123456

2.2 分别进入目录 启动选择后台启动。
	./redis-server redis.conf

#### 3 哨兵模式

3.1 上面三个redis的sentinel.conf分别加入

    目录分别为：/usr/local/redis/redis-6379；/usr/local/redis/redis-6378；/usr/local/redis/redis-6377

	master的sentinel.conf文件
	1 port 26379
	2 # 初次配置时的状态，这个sentinel会自动更新(ip为master服务器ip)
	3 sentinel monitor mymaster 内网ip 6379 2
	4 daemonize yes
	5 logfile "./sentinel_log.log"
    6  sentinel auth-pass mymaster 123456

	slaver1的sentinel.conf文件
	1 port 26378
	2 # 初次配置时的状态，这个sentinel会自动更新(ip为master服务器ip)
	3 sentinel monitor mymaster 内网ip 6379 2
	4 daemonize yes
	5 logfile "./sentinel_log.log"
    6  sentinel auth-pass mymaster 123456
	
    slaver2的sentinel.conf文件
	1 port 26377
	2 # 初次配置时的状态，这个sentinel会自动更新(ip为master服务器ip)
	3 sentinel monitor mymaster 内网ip 6379 2
	4 daemonize yes
	5 logfile "./sentinel_log.log"
    6  sentinel auth-pass mymaster 123456

3.2 分别进入目录启动 

    选择后台启动
	./redis-server redis.conf

    启动哨兵
	./redis-server sentinel.conf --sentinel


6379启动成功如下(以下将配置文件拷入bin下启动):

	[root@iZ2ze7620wvus4xddjgk7pZ bin]# ./redis-server redis.conf 
	[root@iZ2ze7620wvus4xddjgk7pZ bin]# ps aux | grep redis
	root      9022  0.0  0.3 136972  7524 ?        Ssl  11:13   0:00 ./redis-server 172.17.249.255:6379
	root      9026  0.0  0.0 112704   972 pts/0    R+   11:13   0:00 grep --color=auto redis
	[root@iZ2ze7620wvus4xddjgk7pZ bin]# ./redis-server sentinel.conf --sentinel
	[root@iZ2ze7620wvus4xddjgk7pZ bin]# ps aux | grep redis
	root      9022  0.0  0.3 136972  7524 ?        Ssl  11:13   0:00 ./redis-server 172.17.249.255:6379
	root      9030  0.0  0.4 136968  7572 ?        Ssl  11:14   0:00 ./redis-server *:26379 [sentinel]
	root      9034  0.0  0.0 112704   972 pts/0    R+   11:14   0:00 grep --color=auto redis


3.3 查看状态

分别开启redis的客户端
	./redis-cli -h ip -p 6379
	./redis-cli -h ip -p 6378
	./redis-cli -h ip -p 6377
   
    auth 123456
    查看命令：info replication
./redis-cli -h 172.17.249.255 -p 6378

4 注

     一、检查配置文件 ： 一、确保sentinel.conf配置文件不是完全拷贝的，这个文件会在运行之后自动添加一些数据，导致拷贝之后没有删除无法自动切换主从，
	二、确保 redis.conf中两个属性 requirepass masterauth 这两个密码配置都有 ，sentinel.conf中 sentinel auth-pass mymaster (password) 存在。
	三、每个redis.conf配置文件中 slaveof ip port 确保从redis配置中都有该项配置，确保sentinel.conf中
	sentinel monitor mymaster masterip + port + num(该项为数字 一般设为 1 或者2 ) 确保该项在三台服务器上都一致
	四、通过redis-cli 客户端连接上redis 进行auth认证 输入命令 info查看master以及slave情况

关于启用redis密码认证的涉及的几个问题：

1、是否只设置requirepass就可以？masterauth是否需要同步设置？

	答案：redis启用密码认证一定要requirepass和masterauth同时设置。
	
	如果主节点设置了requirepass登录验证，在主从切换，slave在和master做数据同步的时候首先需要发送一个ping的消息给主节点判断主节点是否存活，再监听主节点的端口是否联通，发送数据同步等都会用到master的登录密码，否则无法登录，log会出现响应的报错。也就是说slave的masterauth和master的requirepass是对应的，所以建议redis启用密码时将各个节点的masterauth和requirepass设置为相同的密码，降低运维成本。当然设置为不同也是可以的，注意slave节点masterauth和master节点requirepass的对应关系就行。

2、requreipass和master的作用？
	
	masterauth作用：主要是针对master对应的slave节点设置的，在slave节点数据同步的时候用到。
	
	requirepass作用：对登录权限做限制，redis每个节点的requirepass可以是独立、不同的。


### 参考

    https://blog.csdn.net/u013058742/article/details/80004893
    问题解决：外网不能访问与主从切换问题。
    https://blog.csdn.net/weixin_38669966/article/details/91417389