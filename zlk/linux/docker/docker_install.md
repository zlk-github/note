## 1 Docker常用命令

CentOS7安装Docker见：https://www.runoob.com/docker/centos-

**注：**安装完国内镜像报：

	docker Error response from daemon: Get https://registry-1.docker.io/v2/library/centos/manifests/late.

	（参考：https://blog.csdn.net/dabao87/article/details/86647691）

### 1 docker安装

(http://www.manongjc.com/article/32374.html)

1 启动Docker后台服务

	sudo systemctl start docker

2.重启服务

	systemctl restart docker.service

3 测试运行hello-word

	docker run hello-world

4.运行容器

	docker ps -a  

5.进入mysql容器

    docker exec -it mysql bash  

### 安装mysql

（参考：https://www.cnblogs.com/loovelj/p/7823093.html）

1.pull一个MySQL的image

	docker pull registry.cn-hangzhou.aliyuncs.com/acs-sample/mysql:5.7

2.查看镜像

	docker images

3.修改镜像名字

	docker tag registry.cn-hangzhou.aliyuncs.com/acs-sample/mysql:5.7 mysql:5.7 

4.创建镜像容器

	docker create -it mysql:5.7

5.启动MySQL容器

	docker run --name mysqlserver -e MYSQL_ROOT_PASSWORD=sgcc -d -i -p 3306:3306  mysql:5.7
	
	docker ps

6.进入mysql终端

	docker exec -it  2a7a85124400  /bin/bash

注：2a7a85124400是docker ps查出来的。

7.进入mysql命令行

	mysql -h 127.0.0.1 -u root -p  或者mysql -u root -p

	需要重置密码：ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';

8.退出mysql命令行

	quit或者exit

	[root@localhost mysql]# docker ps
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	37ba718373de        mysql:5.7           "/entrypoint.sh mysq…"   15 minutes ago      Up 15 minutes       0.0.0.0:3306->3306/tcp   mysqlserver
	[root@localhost mysql]# 


tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
