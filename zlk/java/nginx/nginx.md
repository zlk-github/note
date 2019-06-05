## Nginx

### 1 nginx介绍

nginx是一个web服务器，通常用来实现服务器的反向代理。

常见请求与响应有：正常请求、正向代理、反向代理。

**1.1 正常请求**

这是开发中比较常见的方式，由客户端直接请求服务器，然后服务器直接对客户端响应数据。如下图所示。

![Alt text](./images/routine.png)

**1.2 正向代理**

客户端不能直接请求原始服务器，需要先将请求与请求地址发送给代理服务器，然后由代理服务去将请求转发到原始服务器。原始服务器将结果响应给代理服务器，然后由代理服务器将得到的响应结果返回给客户端。如下图所示。

![Alt text](./images/forward.png)


在此过程中，需要在客户端配置代理服务器的地址（hosts文件）。正向代理是在客户端使用的，是对客户端的代理，由客户端知道并去主动代理。（如翻墙等）

正向代理的作用：

	1.用于访问访问不了的资源（如google翻墙;
	2.可以做代理服务器缓存，加上资源访问;
	3.可以对客户端上网进行认证授权（如校园网;
	4.上网行为的管理，对外隐藏用户信息（原始服务器并不知道访问用户是谁。


**1.3 反向代理**

客户端将请求发送到服务器（客户端认为是原始服务器，实际是反向代理服务器），反向代理服务器通过一定的策略将请求转发到服务器集群中的服务器上。然后由集群服务器响应结果。反向代理服务去将结果返回给客户端。

在此过程中。客户端是不知道有没有代理服务器。客户端会认为请求的就是原始服务器。

![Alt text](./images/reverse.png)

反向代理的作用：
	
	1.负载均衡，提高请求处理与响应速度（集群）;
	2.保证内网安全，隐藏服务器信息，防止web攻击。


### 2 nginx 常用命令

默认端口80，配置文件nginx.conf，成功日志access.log，失败日志error.log。

2.1 启动nginx

	sudo nginx 
	
	或者
	sudo nginx -c 配置文件路径（nginx.conf）

2.2 重启nginx

	sudo nginx -s reload

2.3 停止nginx

	sudo nginx -s stop

2.4 侦听nginx端口

	ps aux | grep nginx
	
	或者
	netstat -ntpl | grep 80

2.5 查看nginx版本

	sudo nginx -v

2.6 测试nginx的配置文件是否有格式错误

	sudo nginx -t


### 3 nginx 配置文件说明

nginx.conf说明。

	#nginx用户
	#user  nobody;
	
	#工作进程数,由cpu核心总数决定最大值
	worker_processes  1;
	
	#错误日志位置
	#error_log  logs/error.log;
	
	#PID文件位置（pid为进程id号）
	#pid        logs/nginx.pid;
	
	#工作模式
	events {
	    #每个进程的最大连接数，默认1024；(如每个进程连接数1000，有两个进程数。则可以提供2000个连接)
	    worker_connections  1024;
	}
	
	#http相关与虚拟主机配置
	http {
	    #支持的媒体类型,类型在文件 mime.types中定义
	    include       mime.types;
		#默认类型
	    default_type  application/octet-stream;
	
		#日志的输出格式
	    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	    #                  '$status $body_bytes_sent "$http_referer" '
	    #                  '"$http_user_agent" "$http_x_forwarded_for"';
	
		#访问日志的位置
	    #access_log  logs/access.log  main;
	
		#是否调用sendfile函数输出日志
	    sendfile        on;
	    #tcp_nopush     on;
	
	    #连接超时65s
	    keepalive_timeout  65;
	
		#开启gzip压缩
	    #gzip  on;
		
		#后台请求ip配置
		upstream server_test {
			ip_hash;
			server 127.0.0.1:8088 weight 2;#weight权重
			server 127.0.0.1:8089 weight 1;
		}
	
		#虚拟主机配置
	    server {
		    #侦听端口，默认80
	        listen       80;
			#域名，实际中需要申请。该处测试的时候可以在在hosts中加 (ip localhost)
	        server_name  localhost;
			#编码格式
			charset utf-8;
	
			#虚拟主机日志
	        #access_log  logs/host.access.log  main;
	
			#1前台代理，访问http://localhost时进入前端目录入口D:\Test\vue\vue1\dist\index.html
	        location / {
	            root	 D:\Test\vue\vue1\dist;
	            index  	 index.html;
	        }
			
			#2静态资源F:/static下
			location ~ .*\.（js|css|png|gif）$ {  
	            root F:/static;
	        }
			
			#3图片服务器
			location /images（js|css|png|gif）$ {  
	            root F:/web;
				#开启图片浏览功能
				auto index on;
	        }
			
			#4后台代理，前端访问目录名称
			location ^~ /test/ {
			    #server_test对应upstream server_test
				proxy_pass   http://server_test/test/; 
	        }
			
			#400错误页面
	        error_page  404   /404.html;
	        #500错误页面
	        location = /50x.html {
	            root  html;
	        }
		}
	}




### 4 nginx做http服务器

每台物理服务器划分为多个虚拟服务器，每个虚拟主机对应一个web站点。其实就是一台服务器搭建了多个网站。

虚拟主机的地址区分方式：

	1.ip区分（如一台服务器有多个网卡，或者用多台服务器）
	
	2.端口区分（一台服务器，ip相同，使用端口区分。后台开发比较常用）
	
	3.域名区分（实际网站中常用，需要花钱买域名。在该处使用将域名加到hosts文件的方式，只能用于本地测试）

下面测试

主要配置：

server {
	    #侦听端口，默认80
        listen       80;
		#域名，实际中需要申请。该处测试的时候可以在在hosts中加 (127.0.0.1  www.zlk.com)，127.0.0.1为服务器地址，可以根据服务器地址配置。

        server_name  www.zlk.com;
		#编码格式
		charset utf-8;

		#虚拟主机日志
        #access_log  logs/host.access.log  main;

		#1前台代理，访问http://localhost时访问D:\Test\vue\vue1\dist\index.html
        location / {
            root	 D:\Test\vue\vue1\dist;
            index  	 index.html;
        }
		
        error_page  404   /404.html;
        location = /50x.html {
            root   html;
        }
	}


### 5 nginx 做图片服务器

需要ftp或者sftp.

  server {
		    #侦听端口，默认80
	        listen       80;
			#域名，实际中需要申请。该处测试的时候可以在在hosts中加 (ip localhost)
	        server_name  localhost;
			#编码格式
			charset utf-8;
	
			#虚拟主机日志
	        #access_log  logs/host.access.log  main;
	
			#前台代理，访问http://localhost时进入前端目录入口D:\Test\vue\vue1\dist\index.html
	        location / {
	            root	 D:\Test\vue\vue1\dist;
	            index  	 index.html;
	        }
			
			
			#图片服务器
			location /images（js|css|png|gif）$ {  
	            root F:/web;
				#开启图片浏览功能
				auto index on;
	        }
			
			
	        error_page  404   /404.html;
	        location = /50x.html {
	            root  html;
	        }
		}
	}

### 6 反向代理配置


### 7 负载均衡

### 8 高并发

