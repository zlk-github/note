##   GitHub

### 1 Windows环境下GitHub安装与配置

1.1 下载GitHub并进行安装

  > 下载地址：https://git-scm.com/download/win，进入后将自动下载git安装包后进行安装。
  > 更新git命令：$ git clone git://git.kernel.org/pub/scm/git/git.git


1.2 设置用户名称与邮箱地址
 >设置用户名：$ git config --global user.email 2773407299@qq.com
 >
 > 设置邮箱：$ git config --global user.name "zlk19921105"
 

1.3 检查配置信息
 >检查配置列表：$ git config --list
 >
 >检查特定配置：$ git config <key>
 >
 >例如检查用户名：$ git config user.name

1.4 获取帮助
  >$ git help <verb> 
  >
  >例如获取config的命令手册：$ git help config
  
### 2 Git基础
2.1 获取Git仓库
获取Git项目仓库的两种方式：

1.在现有项目或目录下导入所有文件到Git中；

>命令：$ git init 
>
>例：在d:\git\\zlk
>
>在当前文件（d:\git\\zlk）中打开cmd,输入git init即可创建一个Git仓库。

2.从一个服务器克隆一个现有的Git仓库。



 切换分支：$ git checkout dingdong
![Alt text](./images/15179003611.jpg)