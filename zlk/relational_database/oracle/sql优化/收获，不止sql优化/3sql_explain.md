### 3 Oracle执行计划

### 1 统计信息

一般先访问小表（后访问大表），让其成为驱动表，性能更高。

统计记录数（表USERS，表table_name）。  --注：用count(*)亦可，但是数据多的时候会很慢。

	 t.TABLE_NAME,t.NUM_ROWS,t.BLOCKS,t.LAST_ANALYZED from user_tables t where table_name in('USERS','EXAMINATION')

执行后结果如下：（NUM_ROWS依赖与统计信息，可能和实际不一致）

		TABLE_NAME   NUM_ROWS   BLOCKS      LAST_ANALYZED
	1	EXAMINATION	 3	        5	        2018/3/17 星期六 07:23:14
	2	USERS	     7	        5	        2018/3/16 星期五 23:16:59


注：Oracle会在默认时间收集统计信息，以保证执行计划。

### 2 数据库统计信息采集与数据库动态采样

### 3 获取执行计划

**3.1 explain plan for**

执行：explain plan for SELECT * FROM EXAMINATION e 

查看：select * from table(dbms_xplan.display());
	
	1	Plan hash value: 1256789381
	2	 
	3	---------------------------------------------------------------------------------
	4	| Id  | Operation         | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
	5	---------------------------------------------------------------------------------
	6	|   0 | SELECT STATEMENT  |             |     3 |   369 |     3   (0)| 00:00:01 |
	7	|   1 |  TABLE ACCESS FULL| EXAMINATION |     3 |   369 |     3   (0)| 00:00:01 |
	8	---------------------------------------------------------------------------------

优点：

	1.无需真正执行。

缺点：

	 1.没有运行时相关信息（产生多少逻辑读，多少递归调用，多少次物理读）。

	 2.无法判断处理多少行。

	 3,。无法判断访问了多少次。


**3.2 set autotrace on**（pl/sql中不支持）

执行：set autotrace on SELECT * FROM EXAMINATION e

优点：需要运行完才能出结果（产生多少逻辑读，多少递归调用，多少次物理读）

缺点：需要执行完，而且也看不到表被访问了多少次。

**3.3 statistics_level=all**(后面补上)

需要sys给当前用户授权

	SQL>  grant select on v_$sql to zhoulk11;
	Grant succeeded
	 
	SQL> grant select on v_$session to zhoulk11;
	Grant succeeded
	
	SQL>  grant select on v_$sql_plan_statistics_all to zhoulk11;


SYS@ orcl>grant select on v_$sql_plan to scott;
 
Grant succeeded.
 
SYS@ orcl>grant select on v_$session to scott;
 
Grant succeeded.
 
SYS@ orcl>grant select on v_$sql_plan_statistics_all to scott;
 
Grant succeeded.



执行计划：

	 set serveroutput off

	 alter session set statistics_level=all;
	
	 SELECT * FROM EXAMINATION e ;  或者select /*+ no_index(t1 idx_t1) */ * from EXAMINATION t1
	 
	 select * from table(dbms_xplan.display_cursor(null,null,'allstats last'));
 
结果：

	  
优点：1.starts看到表被访问了多少次;
2.E-ROWS和A-ROWS 对应预测行数与实际行数；
3.BUFFERS对应逻辑读；

缺点：1.需要执行完；
2.无法控制台记录打屏输出；
3.看不出递归次数，看不出物理值；

**3.4dbms_xplan.display_cursor**
 #查询sql_id

	select * from v$sql where last_active_time >=to_date('2019-05-24 11:00:00','yyyy-MM-dd HH24:MI:SS') and last_active_time <=to_date('2019-05-24 15:00:00','yyyy-MM-dd HH24:MI:SS') ;
 
  select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn',0));
 
  select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn'));

结果：



优缺点和explain plan for一样，区别在于他是真实的执行计划。

**3.5事件10046trace追踪**

注：复杂，看不到访问次数。有物理读。

**3.6awrsqrpt.sql**


**差异**

	sql执行时间长或者无返回结果，选择方法1；

	跟踪sql最简单方法选方法1，其次方法2；

	观察某条sql多个执行计划，选择4和6；

	sql中有函数，或者嵌套多，选择方法5；

	想看真实计划，不能用1和2；

	想取得表被访问次数，选择3.


### 4 执行计划排查

1.真实返回和逻辑读差异是不是很大；

2.评估条数与真实条数是不是差距很大。

3.类型转换不用索引，是filter不是accss.

4.函数引起的递归过多。

5.分页中，count stopkey关键字。

6.sql排序，需要磁盘排序（disk），而不是内存排序（memory）。
