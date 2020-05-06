## Elasticsearch（需要修改）

索引(index):类似于数据库，也就是一组文档的结合。

类型(type)：类似于表，ES5版本一个索引可以有多个类型，ES6版本一个索引只能有一个类型，ES7版本移除索引概念。

映射(mapping)：类似于数据库中表结构定义。

文档(document)：类似于数据库中一行记录。

字段：类似于数据库中字段。

集群：一个或者多个节点组成（即多台机器）。

分片(shard): 因为 ES 是个分布式的搜索引擎, 所以索引通常都会分解成不同部分, 而这些分布在不同节点的数据就是分片. ES自动管理和组织分片, 并在必要的时候对分片数据进行再平衡分配, 所以用户基本上不用担心分片的处理细节.

副本(replica): ES 默认为一个索引创建 5 个主分片, 并分别为其创建一个副本分片. 也就是说每个索引都由 5 个主分片成本, 而每个主分片都相应的有一个 copy。对于分布式搜索引擎来说, 分片及副本的分配将是高可用及快速搜索响应的设计核心.主分片与副本都能处理查询请求，它们的唯一区别在于只有主分片才能处理索引请求.副本对搜索性能非常重要，同时用户也可在任何时候添加或删除副本。额外的副本能给带来更大的容量, 更高的呑吐能力及更强的故障恢复能力。


### 索引

**1.1** 创建索引

	-- curl -X PUT "ip:端口/索引名称"
	curl -X PUT "localhost:9200/indexName"

**1.2** 删除索引

	curl -X DETELE "localhost:9200/indexName"


**1.3** 获取索引

    --获取全部索引
	curl -X GET "localhost:9200/_all"
	curl -X GET "localhost:9200/_cat/indices?v"


    --获取索引(多个逗号隔开)
	curl -X GET "localhost:9200/indexName,indexName2"


**1.4** 判断索引是否存在（postman里面使用HEAD）


	curl I "localhost:9200/indexName"

    200表示存在


**1.5** 关闭开启索引

	curl -X POST "localhost:9200/indexName/_close"
	curl -X POST "localhost:9200/indexName/_open"



### 映射






