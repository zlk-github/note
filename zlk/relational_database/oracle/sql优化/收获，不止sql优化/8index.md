## 8 索引优化sql

### 1 索引三大特性

**索引的高度比较低**：查询快，快速定位。

**索引本身能存储列值**：索引本身存储列值（索引值+rowid），用来优化count(*),sum(索引类)等函数。

**索引本身有序**：优化MAX/MIN，ORDER BY等排序。

**注：**建议表字段尽量不为null。因为索引的时候字段为null会导致索引失败（不加 索引字段 is not null排除的情况下。），

**一般需要建立索引的字段**

	1、经常用在where语句之后的字段
	
	2、主键或者外键
	
	3、字段具有唯一性的时候建立唯一性索引
	
	4、在经常需要根据范围进行搜索的列上创建索引，因为索引已经排序，其指定的范围是连续的

	5、返回数据占总数的5%以内。

优点：查询优化后变快。

缺点：建索引需要占空间，而且需要花时间维护。更新数据需要更新索引来保持索引有序。

### 2 单索引优化sql

测试数据1000000条。

表t7结构（表未设置主键）

    名称        类型             是否为空
	ID	        NUMBER	        N
	ID2  	    NUMBER	        N
	CONTENTS	VARCHAR2(1000)	N

**2.1.索引存储值优化count**

	 drop index idx1_t7_id2

	 1.select count (*) from t7 --11.373s
	 2.select count (*) from t7 where id2 is not null --11.662s
	 3.select count (1) from t7 --11.186s
	 4.select count (id2) from t7 --11.653

	 create index idx1_t7_id2 on t7(id2)

	 1.select count (*) from t7 --12.136s
	 2.select count (*) from t7 where id2 is not null --0.473s
	 3.select count (1) from t7 --11.778s
	 4.select count (id2) from t7 --0.472s
	

观察可以看出，1、3、5对应sql执行时间基本没有变化。

但是2、4对应sql都从11秒左右提升到0.47s左右（第二次查询达到了0.063）。时间缩短了20多倍。明显索引列（**id2**）在sql语句中被使用到。

**注**：count使用索引统计时优化时，sql中需要用到索引列，且**该列值不能为空（如果为null，需要加is not null剔除列里面的空值），否则索引失效。如果索引列主键不为空，count(*)会用到索引。**

**2.2 索引存储列值sum与avg**

	drop index idx1_t7_id2
	
	select sum (id2) from t7  --11.139s
	select sum (id2) from t7  where id2 is not null--12.044s
	 
	create index idx1_t7_id2 on t7(id2)
	   
	select sum (id2) from t7  --1.375s
	select sum (id2) from t7  where id2 is not null--1.326s （效果等价于索引列不为null）

sum (索引列)可以优化sum函数查询，前提是索引列不为null或者排除索引列的空值，avg效果一样。

**2.3索引本身有序之order by**

	drop index idx1_t7_id2
	
	1.select *  from t7 order by id2 --27.176s
	2.select id2 from t7  order by id2 --12.356s
	3.select id,id2 from t7 order by id2 --11.529s
	4.select * from t7 where id2 >0 order by id2 --27.3s
	5.select * from t7 where id2 >0 and id2<10000 order by id2 --12.012s
	6.select * from t7 where id2=3 order by id2 --12.3s
	 
	create index idx1_t7_id2 on t7(id2)
	
	1.select * from t7  order by id2  --25.586s
	2.select id2 from t7  order by id2 --0.452s
	3.select id,id2 from t7 order by id2 --11.435s
	4.select * from t7 where id2 >0 and id2<10000 order by id2 --0.032s（id2必须字段最大与最小范围，此处只是缩小了搜索范围，否则无效）
	5.select * from t7 where id2 =3 order by id2 --0.031s

观察会发现2,4,5对应sql执行时间变短。此时不是使用order by的排序，而是使用索引的排序。

	1.返回字段只有索引字段，以索引字段进行排序。索引有效。
	2.返回字段不止索引字段，以索引字段排序，此时索引字段必须在where中指定范围（作用是缩写范围，个人认为不是索引的效果）。

**2.4索引有序优化max与min**

	drop index idx1_t7_id2 
	  
	1.select max(id2) from t7   --12.309s
	2.select min(id2) from t7   --12.169s
	3.select max(id2),min(id2) from t7   --12.465s
	4.select a.max,b.min from (select max(id2) max from t7) a,(select min(id2) min from t7 ) b --22.573s
	
	create index idx1_t7_id2 on t7(id2)
	  
	1.select max(id2) from t7 --0.608s
	2.select min(id2) from t7   --0.436s
	3.select max(id2),min(id2) from t7   --1.279s
	4.select a.max,b.min from (select max(id2) max from t7) a,(select min(id2) min from t7 ) b --0.031

注：走索引时，4比3效果好。

### 3 组合索引优化sql

适用场景：单列查询结果多，组合查询结果少。(按索引创建顺序生效，中间索引断层（where条件中），左边索引字段生效，右边索引字段不生效)


	1.需要考虑组合顺序；
	2.只有等值查询是，组合索引顺序不影响性能；
	3.一般将等值列放在索引前面。

**组合索引sql案例**

1.范围查询时，不要使用in,应该使用范围（>，<）

### 4 分区索引

如果表关联查询时分区条件无法使用到，此时全局索引性能会比分区索引效果好（索引高度原因）。

### 5 索引的失效

**5.1 逻辑失效**

	1.索引不能存储空值，否则索引失效。（用is not null索引字段会有效）；
	
	2.like会使索引失效，以%开头。(但是索引开头能确定的时候like可以用到索引）；
	
	3.order by(除非order by 后字段出现在where条件中，或者只是返回order by后的索引字段才会索引生效)；
	
	4.对索引列进行运算将用不到索引，应该讲索引列放在比较运算符的左边（=,<,>等），运算逻辑放右边；

    5.索引列发生类型转换；

    6.条件中用or，即使其中有条件带索引，也不会使用索引查询；

    7.对于多列索引，不是使用的第一部分，则不会使用索引；

	8.组合索引的第一列没有出现在where条件中时。


**5.2 物理失效**

	1.move操作，需要重建索引；
	
	2.分区表导致。

### 总结

由于索引的建立会造成开销，且会使增删改需要维护索引顺序等原因。建立索引时不应该出现无用或者大量重复交叉的索引。且组合索引列不应该超过4个。索引的选择应该建在数据量大，但是返回数据少的表。

### 参考

	[1]粱敬彬，粱敬弘。 收获，不止SQL优化[J].电子工业出版社，2017.6