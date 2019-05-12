## mongoDB常用命令

### 1 启动MongoDB服务

	MongoDB 目录的 bin 目录中执行 mongod.exe 文件

	进入MongoDB\bin目录下：
	mongod --dbpath D:\Program Files\mongodb\data\db  （D:\Program Files\mongodb\为mongoDB安装路径）

    或者（初始化服务的情况）
	启动MongoDB服务
	net start MongoDB
	
	关闭MongoDB服务
	net stop MongoDB

### 2 进入mongoDb

运行 bin目录下mongo.exe 

D:\Program Files\mongodb\bin\mongo.exe


### 3 数据库

**3.1 show dbs 命令可以显示所有数据的列表**

	> show dbs
	local  0.078GB
	test   0.078GB

	说明：
	admin： 从权限的角度来看，这是"root"数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。
	local: 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合
	config: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息

**3.2 db 命令用于查看当前操作的文档**（数据库）

	> db
	test
 	>

**3.3 创建或切换库**

数据库不存在则创建，存在则切换。需要有数据，show dbs才会显示。

命令：use <数据库>

	例：
	> use myLocal
	switched to db myLocal
 	>

**3.4 数据库插入数据**

db.<数据库>.insert({"name":"1111"});**该处会自动创建集合**。

	例：
	> db.myLocalhost.insert({"name":"1111"})
	WriteResult({ "nInserted" : 1 })


**3.5 删除当前数据库**

> db.dropDatabase()
{ "dropped" : "runoob", "ok" : 1 }

### 4 集合

**4.1 创建集合**

	语法格式：
	db.createCollection(name, options)
	
	参数说明：
	
		name: 要创建的集合名称
		options: 可选参数, 指定有关内存大小及索引的选项

例：在 test 数据库中创建 runoob 集合，需要先切换到test数据库。

	> use test
	switched to db test
	> db.createCollection("runoob")
	{ "ok" : 1 }


	或者：
	> db.createCollection("mycol", { capped : true, autoIndexId : true, size : 
	6142800, max : 10000 } )
	{ "ok" : 1 }
	>

**4.2 查看已有集合**

show collections 或者 show tables

	> show collections
	runoob
	system.indexes

**4.3 删除集合**

db.<集合>.drop()

例：删除集合runoob

	>db.runoob.drop()
	true


### 5 文档

**5.1 插入文档**

db.<集合>.insert(document)；集合不存在时会自动创建。

例：向col集合插入一个文档。

	> db.col.insert({"title":"MongoDB","url":"路径"})))
	WriteResult({ "nInserted" : 1 })

**我们也可以将数据定义为一个变量，如下所示：**

	1.建文档document
	> document=({title: 'MongoDB 教程', 
	    description: 'MongoDB 是一个 Nosql 数据库',
	    by: '菜鸟教程',
	    url: 'http://www.runoob.com',
	    tags: ['mongodb', 'database', 'NoSQL'],
	    likes: 100
	});
	 
	2.文档document保存到集合col
	db.col.insert(document) 或者 db.col.save(document)


**5.2 查看集合里面的文档**

db.<集合>.find()

例：col集合里面插入的两个文档。

	> db.col.find()
	{ "_id" : ObjectId("5ccfa7aba9e235c3e4d8e739"), "title" : "MongoDB" }
	{ "_id" : ObjectId("5ccfa7e3a9e235c3e4d8e73a"), "title" : "MongoDB", "url" : "路径" }


**5.3 更新集合**

**5.3.1** update()

	update() 方法用于更新已存在的文档。语法格式如下：
	
	db.collection.update(
	   <query>,
	   <update>,
	   {
	     upsert: <boolean>,
	     multi: <boolean>,
	     writeConcern: <document>
	   }
	)

	参数说明：
	query : update的查询条件，类似sql update查询内where后面的。
	update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
	upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
	multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
	writeConcern :可选，抛出异常的级别。

例：

	db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})

**5.3.2** save() 方法

	save() 方法通过传入的文档来替换已有文档。语法格式如下：
	
	db.collection.save(
	   <document>,
	   {
	     writeConcern: <document>
	   }
	)
	参数说明：
	
	document : 文档数据。
	writeConcern :可选，抛出异常的级别。


例：将id为5ccfa7aba9e235c3e4d8e739的文档更换如下。

	>db.col.save({
	    "_id" : ObjectId("5ccfa7aba9e235c3e4d8e739"),
	    "title1" : "MongoDB111"
	})



**5.3.3** 删除文档：

	db.collection.remove(
	   <query>,
	   {
	     justOne: <boolean>,
	     writeConcern: <document>
	   }
	)
	
	参数说明：
	
	query :（可选）删除的文档的条件。
	justOne : （可选）如果设为 true 或 1，则只删除一个文档，如果不设置该参数，或使用默认值 false，则删除所有匹配条件的文档。
	writeConcern :（可选）抛出异常的级别。

例：

	>db.col.remove({'title':'MongoDB 教程'})
	>

**5.4 查询文档**

	db.collection.find(query, projection)

	query ：可选，使用查询操作符指定查询条件
	projection ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）。

除了 find() 方法之外，还有一个 findOne() 方法，它只返回一个文档。
如果你需要以易读的方式来读取数据，可以使用 pretty() 方法，语法格式如下：

	>db.col.find().pretty()


**5.4.1**条件语句查询

	操作		格式						范例												RDBMS中的类似语句
	等于		{<key>:<value>}	       		 db.col.find({"by":"菜鸟教程"}).pretty()		where by = '菜鸟教程'
	小于		{<key>:{$lt:<value>}}		db.col.find({"likes":{$lt:50}}).pretty()	  where likes < 50
	小于或等于 {<key>:{$lte:<value>}}		db.col.find({"likes":{$lte:50}}).pretty()	where likes <= 50
	大于		{<key>:{$gt:<value>}}		db.col.find({"likes":{$gt:50}}).pretty()	where likes > 50
	大于或等于 {<key>:{$gte:<value>}}		db.col.find({"likes":{$gte:50}}).pretty()	where likes >= 50
	不等于	   {<key>:{$ne:<value>}}	    db.col.find({"likes":{$ne:50}}).pretty()	where likes != 50

**5.4.2**AND

	>db.col.find({key1:value1, key2:value2}).pretty()

**5.4.3** OR

	>db.col.find(
	   {
	      $or: [
	         {key1: value1}, {key2:value2}
	      ]
	   }
	).pretty()

例：

	db.col.find({$or:[{"by":"菜鸟教程"},{"title": "MongoDB 教程"}]}).pretty()

###6 $type 匹配

例：匹配title是string类型数据（String对应MongoDB类型中的2）

	db.col.find({"title" : {$type : 2}})
	或
	db.col.find({"title" : {$type : 'string'}})

### 7 limit与skip

从NUMBER2+1开始，显示NUMBER1条，显示。默认skip为0;

db.COLLECTION_NAME.find().limit(NUMBER1).skip(NUMBER2)

例：指定返回title字段，

	db.col.find({},{"title":1,_id:0}).limit(1).skip(1)


### 8 排序

其中 1 为升序排列，而 -1 是用于降序排列。

	db.COLLECTION_NAME.find().sort({KEY:1})

例：likes降序

	db.col.find({},{"title":1,_id:0}).sort({"likes":-1})

### 9 索引

9.1 创建索引

keys为数据字段，1 为指定按升序创建索引，如果你想按降序来创建索引指定为 -1。options为参数。


	db.collection.createIndex(keys, options)

例：

	db.col.createIndex({"title":1,"description":-1})

**9.2** 查看集合索引

	db.col.getIndexes()

**9.3** 查看集合索引大小

	db.col.totalIndexSize()

**9.4** 删除集合所有索引

	db.col.dropIndexes()

**9.5** 删除集合指定索引

	db.col.dropIndex("索引名称")

### 10 聚合

**10.1** aggregate()

	db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)

聚合的表达式

	$sum	计算总和。						db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])
	$avg	计算平均值						db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])
	$min	获取集合中所有文档对应值得最小值。	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])
	$max	获取集合中所有文档对应值得最大值。	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])
	$push	在结果文档中插入值到一个数组中。	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])
	$addToSet	在结果文档中插入值到一个数组中，但不创建副本。	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])
	$first	根据资源文档的排序获取第一个文档数据。	db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])
	$last	根据资源文档的排序获取最后一个文档数据   db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])

**10.2** 管道

### 11 权限

以用户管理员的身份登录 admin 数据库。然后用 use 命令切换到目标数据库，同样用 db.createUser() 命令来创建用户，其中角色名为 “readWrite”。

普通的数据库用户角色有两种，read 和 readWrite。顾名思义，前者只能读取数据不能修改，后者可以读取和修改。
下面是一个例子：

	> use test
	switched to db test
	> db.createUser({user:"testuser",pwd:"testpass",roles:["readWrite"]})
	Successfully added user: { "user" : "testuser", "roles" : [ "readWrite" ] }
	> db.auth("testuser","testpass")
	1

**参考：**

	https://www.runoob.com/mongodb/mongodb-intro.html