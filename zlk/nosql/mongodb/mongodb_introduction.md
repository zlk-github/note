## Mongodb入门介绍

安装步骤见："windows7下MongoDB的安装"

### 介绍
Mongodb 中集合类似于关系型数据库中的表，文档类似于行。
格式类似于json的key/value;
key必须是字符串，value可以string，int，float，timestamp，binary 等类型。

**适合场景：**

1网站实时数据的处理。

2Mongo 搭建的持久化缓存层可以避免下层的数据源过载。

3大尺寸、低价值的数据存放。

4数十或数百台服务器组成的数据库。

5BSON 数据格式非常适合文档化格式的存储及查询。

不适合场景：

1高度事务性的系统。

2传统的商业智能应用。

3需要SQL 的问题。

### 权限设置

### 简例

====================================
## 介绍

mongodb中基本的概念是文档、集合、数据库

	SQL术语/概念	MongoDB术语/概念	  解释/说明
	database	   database				数据库
	table		   collection			数据库表/集合
	row			   document				数据记录行/文档
	column		   field				数据字段/域
	index		   index				索引
	table 		   joins	        	表连接,MongoDB不支持
	primary key	   primary key	        主键,MongoDB自动将_id字段设置为主键