## Ant Design Vue 

### 1 安装node.js

下载地址：http://nodejs.cn/download/
	
	测试node是否安装成功：node --version;
	测试npm是否可用：npm -v;

### 2 安装cnpm（可选）
	
	安装：npm install -g cnpm --registry=https://registry.npm.taobao.org 
	测试：cnpm –v

安装cnpm后，后面的npm可以换为cnpm

### 3 安装npm

	npm install ant-design-vue --save

### 4 安装脚手架工具vue-cli

    npm install -g vue-cli

### 3 创建项目
     
	vue init webpack antd-demo
    --vue init webpack 项目名 （对应命令--）


注：安装缓慢可以用cnpm安装：rm -rf node_modules && cnpm install

### 4 使用组件

	 npm i --save ant-design-vue

### 5 根据前端项目的依赖关系下载好相关的组件

	npm install

注：如果install报错

	删除以前安装的 node_modules :
	npm cache clean
	npm install

### 6 编译(平时开发的时候不需要，只需要5、6即可)

	cd antd-demo
	npm run build

    会生成一个dist文件夹，里面的内容可以放到服务器上部署。

### 7 运行

	cd antd-demo
	npm run serve
	--npm run dev

注：以上如果速度慢，可以考虑使用cnpm。需要安装淘宝镜像（npm install -g cnpm --registry=https://registry.npm.taobao.org）。
但是公司内网可能会install失败,此时可以不用内网来cnpm install。

### 使用 babel-plugin-import

npm add babel-plugin-import --dev

### 参考

	https://vue.ant.design/docs/vue/introduce-cn/

    https://www.runoob.com/nodejs/nodejs-npm.html
 
    https://vuejs.org/v2/style-guide/