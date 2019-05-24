##########Oracle优化相关《收获，不止SQL优化》#############

#########第三章 sql执行计划###################

#用户下所有表生成统计数据(未测试通)
DBMS_STATS.GATHER_TABLE_STATS('zhoulk11', 'EXAMINATION');

##1统计表记录数
select t.TABLE_NAME,t.NUM_ROWS,t.BLOCKS,t.LAST_ANALYZED from user_tables t where table_name in('USERS','EXAMINATION')

select * from EXAMINATION

##2 explain plan for 
 
explain plan for SELECT * FROM EXAMINATION e where exam_no='43a0a467ef6b432f99260e2b863f82eb' and exam_name='Maven测试'

 select * from table(dbms_xplan.display());
 
 ##3  set autotrace on(未测试通过)
 
 set autotrace on SELECT * FROM EXAMINATION e；

##4 statistics_level=all

alter session set statistics_level=all;

 SELECT * FROM EXAMINATION e ;
 
 select * from table(dbms_xplan.display_cursor(null,null,'allstats last'));
 
 ##4 dbms_xplan.display_cursor
 #查询sql_id
 select * from v$sql where last_active_time >=to_date('2019-05-24 11:00:00','yyyy-MM-dd HH24:MI:SS') and last_active_time <=to_date('2019-05-24 15:00:00','yyyy-MM-dd HH24:MI:SS') ;
 
 select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn',0));
 
  select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn'));
