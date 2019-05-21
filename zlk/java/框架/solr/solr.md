## Solr

### 1 介绍
java：Solrj
### 2 启动

	cd bin
	solr.cmd start

    #多节点启动
	solr start -e cloud

    #停止 -all所有，或者端口8983
	solr.cmd stop -all

访问地址：http://localhost:8983/solr/#/

### 3 集合与分片

1.创建集合qfy，分片一个，两个副本

	http://10.143.79.85:8080/solr/admin/collections?action=CREATE&name=qfy&numShards=1&replicationFactor=2

2.删除集合qfy

	http://10.143.79.85:8080/solr/admin/collections?action=DELETE&name=qfy

3.solr控制台删除索引命令

	<delete><query>*:*</query></delete>
	<commit/>

### 4 java Solr

Spring Boot2.0项目集成Solr

**4.1** pom.xml

添加Solr



### 参考

	http://lucene.apache.org/solr/guide/7_7/solr-tutorial.html