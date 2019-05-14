## linux命令

### 快捷键

	1、Tab           补全
	
	2、上键/下键      前一条或者后一条命令


### 1 查看ip

ip addr show 或者 ifconfig -a

如下ip为192.168.216.142

	[root@localhost /]# ifconfig -a
	eno16777736: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
	        inet 192.168.216.142  netmask 255.255.254.0  broadcast 192.168.217.255
	        inet6 fe80::20c:29ff:fe76:8819  prefixlen 64  scopeid 0x20<link>
	        ether 00:0c:29:76:88:19  txqueuelen 1000  (Ethernet)
	        RX packets 19607  bytes 1705221 (1.6 MiB)
	        RX errors 0  dropped 1  overruns 0  frame 0
	        TX packets 329  bytes 60843 (59.4 KiB)
	        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
	
	lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
	        inet 127.0.0.1  netmask 255.0.0.0
	        inet6 ::1  prefixlen 128  scopeid 0x10<host>
	        loop  txqueuelen 0  (Local Loopback)
	        RX packets 0  bytes 0 (0.0 B)
	        RX errors 0  dropped 0  overruns 0  frame 0
	        TX packets 0  bytes 0 (0.0 B)
	        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

### 2 目录

**2.1 切换目录cd**
    cd ~          当前账号根目录
    cd /          切换到根目录
    cd ../        上级目录
    cd ./         当前目录
    cd home      当前目录下的home文件夹


**2.2 文件目录属性ls**

ls 当前文件夹下所有文件与文件夹目录列表
	
属性：

	-a ：全部的文件，连同隐藏档( 开头为 . 的文件) 一起列出来(常用)
	-d ：仅列出目录本身，而不是列出目录内的文件数据(常用)
	-l ：长数据串列出，包含文件的属性与权限等等数据；(常用) ls -l即 ll

例子：

	[root@localhost /]# ls
	bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
	[root@localhost /]# ll
	总用量 28
	lrwxrwxrwx.   1 root root    7 7月  16 2018 bin -> usr/bin
	dr-xr-xr-x.   4 root root 4096 1月  10 18:31 boot
	.......

**说明**：

Linux中**第一个字符**代表这个文件是目录、文件或链接文件等等。

	当为[ d ]则是目录
	当为[ - ]则是文件；
	若是[ l ]则表示为链接文档(link file)；
	若是[ b ]则表示为装置文件里面的可供储存的接口设备(可随机存取装置)；
	若是[ c ]则表示为装置文件里面的串行端口设备，例如键盘、鼠标(一次性读取装置)。

接下来的字符中，以**三个为一组**，且均为『rwx』 的三个参数的组合。其中，[ r ]代表可读(read)、[ w ]代表可写(write)、[ x ]代表可执行(execute)。 要注意的是，这三个权限的位置不会改变，如果没有权限，就会出现减号[ - ]而已。

每个文件的属性由左边第一部分的10个字符来确定
![Alt text](./images/ll.png)

	从左至右用0-9这些数字来表示。
	
	第0位确定文件类型，第1-3位确定属主（该文件的所有者）拥有该文件的权限。
	
	第4-6位确定属组（所有者的同组用户）拥有该文件的权限，第7-9位确定其他用户拥有该文件的权限。
	其中，第1、4、7位表示读权限，如果用"r"字符表示，则有读权限，如果用"-"字符表示，则没有读权限；
	
	第2、5、8位表示写权限，如果用"w"字符表示，则有写权限，如果用"-"字符表示没有写权限；第3、6、9位表示可执行权限，如果用"x"字符表示，则有执行权限，如果用"-"字符表示，则没有执行权限。

**2.3 更改文件属性chgrp**

	chgrp [-R] 属组名 文件名

**2.4 当前目录pwd**

	[root@localhost lib64]# pwd
	/lib64

**2.5 创建目录mkdir**

mkdir 目录名  （mkdir-p 目录名  目录存在，会覆盖 ）

	[root@localhost opt]# ls
	[root@localhost opt]# mkdir MyDir
	[root@localhost opt]# ll
	总用量 0
	drwxr-xr-x. 2 root root 6 5月  14 17:32 MyDir

**2.6 删除目录rmdir**

rmdir [-mp] 目录名称

选项：

	-m ：配置文件的权限喔！直接配置，不需要看默认权限 (umask) 的脸色～
	-p ：帮助你直接将所需要的目录(包含上一级目录)递归创建起来！

例子：

	[root@localhost opt]# ll
	总用量 0
	drwxr-xr-x. 2 root root 6 5月  14 17:32 MyDir
	[root@localhost opt]# rmdir MyDir
	[root@localhost opt]# ll
	总用量 0
	[root@localhost opt]# 

**2.7 复制文件或目录cp**

cp [-adfilprsu] 来源档(source) 目标档(destination

cp [options] source1 source2 source3 .... directory

**scp** --- 主要是在不同的Linux系统之间来回copy文件

选项与参数：

	-a：相当於 -pdr 的意思，至於 pdr 请参考下列说明；(常用)
	-d：若来源档为连结档的属性(link file)，则复制连结档属性而非文件本身；
	-f：为强制(force)的意思，若目标文件已经存在且无法开启，则移除后再尝试一次；
	-i：若目标档(destination)已经存在时，在覆盖时会先询问动作的进行(常用)
	-l：进行硬式连结(hard link)的连结档创建，而非复制文件本身；
	-p：连同文件的属性一起复制过去，而非使用默认属性(备份常用)；
	-r：递归持续复制，用於目录的复制行为；(常用)
	-s：复制成为符号连结档 (symbolic link)，亦即『捷径』文件；
	-u：若 destination 比 source 旧才升级 destination ！

例：将文件夹myDir2复杂到myDir文件夹下。名称取为myDir2

	[root@VM_0_13_centos opt]# cp -a  myDir2 /opt/myDir/myDir2
	[root@VM_0_13_centos opt]# ls
	myDir  myDir2  rh
	[root@VM_0_13_centos opt]# cd myDir
	[root@VM_0_13_centos myDir]# ls
	myDir2
	[root@VM_0_13_centos myDir]# 

**2.8 移动文件与目录，或修改名称mv**

mv [-fiu] source destination

mv [options] source1 source2 source3 .... directory

选项与参数：

	-f ：force 强制的意思，如果目标文件已经存在，不会询问而直接覆盖；
	-i ：若目标文件 (destination) 已经存在时，就会询问是否覆盖！
	-u ：若目标文件已经存在，且 source 比较新，才会升级 (update)

例：myDir2移动到opt目录下。

	[root@VM_0_13_centos opt]# ls
	myDir  rh
	[root@VM_0_13_centos opt]# cd myDir/
	[root@VM_0_13_centos myDir]# mv -i myDir2 /opt
	[root@VM_0_13_centos myDir]# ls
	[root@VM_0_13_centos myDir]# cd ../
	[root@VM_0_13_centos opt]# ls
	myDir  myDir2  rh
	[root@VM_0_13_centos opt]# 


### 3 文件

**3.1** 新建文件touch 

touch 文件名

	[root@localhost opt]# touch myFile.txt
	[root@localhost opt]# ll
	总用量 0
	drwxr-xr-x. 2 root root 6 5月  14 17:49 myDir
	 -rw-r--r--. 1 root root 0 5月  14 18:04 myFile.txt
	[root@localhost opt]# 


**3.2 删除文件rm**

rm [选项] 文件

选项说明：
	
	-f　　　　-force　　　　　　忽略不存在的文件，强制删除，无任何提示
	-i　　　　--interactive　　　 进行交互式地删除
	-r | -R　　--recursive　　　  递归式地删除列出的目录下的所有目录和文件，非常危险的选项
	-v　　　   --verbose　　　　详细显示进行的步骤

**例子**：

	1、常规删除a.txt文件
	[root]# rm a.txt
	
	2、强行删除file.log文件	
	[root]# rm -f file.log
	 
	3、删除dirname目录下的所有东西
	[root]# rm -R dir dirname
	
	4、删除以 -f 开头的文件
	[root]# touch ./-f
	[root]# ls ./-f
	./-f
	[root]# rm ./-f
	
	或者使用
	[root]# touch -- -f 
	[root]# ls -- -f 
     -f
	[root]# rm -- -f   

**3.3 解压文件**

**zip**

	zip -r archive_name.zip filename    （-r是压缩文件）
	unzip archive_name.zip              （解压文件在当前文件下）
	unzip archive_name.zip -d new_dir   （解压文件可以将文件解压缩至一个你指定的的目录，使用-d参数）

**tar**

	只是一个打包工具，并不负责压缩。下面是如何打包一个目录：

      tar -cvf archive_name.tar directory_to_compress      

      打包之后如何解包：
      tar -xvf archive_name.tar

     上面这个解包命令将会将文档解开在当前目录下面。当然，你也可以用下面的这个命令来解包到指定的路径：
      tar -xvf archive_name.tar -C new_dir        （解包的参数是-C，不是小写c）

**rar**
	
	将/etc 目录压缩为etc.rar 命令为：
	rar a etc.rar /etc
	
	将etc.rar 解压 命令为：
	rar x etc.rar 
	unrar -e etc.tar

参数：
      -c参数是建立新的存档
      -v参数详细显示处理的文件
      -f参数指定存档或设备
	  -x：解压
	  -t：查看内容
	  -r：向压缩归档文件末尾追加文件

说明：

	tar -xvf file.tar //解压 tar包
	
	tar -xzvf file.tar.gz //解压tar.gz
	
	tar -xjvf file.tar.bz2   //解压 tar.bz2
	
	tar -xZvf file.tar.Z   //解压tar.Z
	
	unrar e file.rar //解压rar
	
	unzip file.zip //解压zip

**3.4 linux之间上传文件**

	1、把本机的文件传给目的服务器：
	scp get66.pcap root@192.168.1.147:/super
	备注：把本机get66.pcap拷贝到147这台服务器的super目录下，需要提供147的密码
	
	2、在本机上执行scp，把远端的服务器文件拷贝到本机上：
	scp root@192.168.1.147:/super/dns.pcap /

	3、拷贝目录下的所有文件：
	scp -r /super/ root@192.168.1.145:/
	备注：把/super/目录下的所有文件，拷贝到145服务器根目录下

**3.5 windows上传linux**

方式一：

需要在linux主机上，安装上传下载工具包rz及sz
（xshell中选ZMODEM，安装命令 yum install -y lrzsz）。
（https://www.linuxidc.com/Linux/2015-05/117975.htm）

输入rz将弹出文件选择。

方式二： sftp操作get/put

### 4 其余常用命令

**4.1 启动命令**

命令前加上bash 或 sh 或 ./

	如 ./startup.sh

**4.2 查看进程**

方法一

1、查Tomcat

	ps -aux | grep tomcat

2、查java

	jps或者ps -aux | grep java

方法二：直接使用 netstat   -anp   |   grep  portno

即：netstat –apn | grep 8080

	1、ps 命令用于查看当前正在运行的进程。
	grep 是搜索
	例如： ps -ef | grep java
	表示查看所有进程里 CMD 是 java 的进程信息
	2、ps -aux | grep java
	-aux 显示所有状态
	ps

**4.3 kill 命令用于终止进程**

	例如： kill -9 [PID]
	 -9 表示强迫进程立即停止
	通常用 ps 查看进程 PID ，用 kill 命令终止进程

### 5 vi常用

打开文件：vi 文件名

如：vi server.xml 

命令模式：

	i 切换到输入模式，以输入字符。
	x 删除当前光标所在处的字符。
	: 切换到底线命令模式，以在最底一行输入命令

输入模式

	在命令模式下按下i就进入了输入模式。
	
	在输入模式中，	：
	
	字符按键以及Shift组合，输入字符
	ENTER，回车键，换行
	BACK SPACE，退格键，删除光标前一个字符
	DEL，删除键，删除光标后一个字符
	方向键，在文本中移动光标
	HOME/END，移动光标到行首/行尾
	Page Up/Page Down，上/下翻页
	Insert，切换光标为输入/替换模式，光标将变成竖线/下划线
	ESC，退出输入模式，切换到命令模式

底线命令模式

	在命令模式下按下:（英文冒号）就进入了底线命令模式。
	
	底线命令模式可以输入单个或多个字符的命令，可用的命令非常多。
	
	在底线命令模式中，基本的命令有（已经省略了冒号）：
	
	q 退出程序
	w 保存文件
    注：强退:q!