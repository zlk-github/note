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

 SELECT * FROM user_tables e ;
 
 SELECT * FROM EXAMINATION e ;
 
 select * from table(dbms_xplan.display_cursor(null,null,'allstats last'));
 
 ##4 dbms_xplan.display_cursor
 #查询sql_id
 select * from v$sql where last_active_time >=to_date('2019-05-24 11:00:00','yyyy-MM-dd HH24:MI:SS') and last_active_time <=to_date('2019-05-24 15:00:00','yyyy-MM-dd HH24:MI:SS') ;
 
 select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn',0));
 
  select * from table(dbms_xplan.display_cursor('aq8yqxyyb40nn'));

##3.5事件10046trace追踪

##3.6awrsqrpt.sql

#########第四章 左右 sql执行计划###################

##1HINT

##(1)子查询
##grant all on scott.dept to zhoulk11;
drop table emp purge;
create table emp as select * from scott.emp;
create index idx_emp_deptno on emp(deptno);
create index idx_emp_empno on emp(empno);
drop table dept purge;
create table dept as select * from scott.dept;
create index idx_dept_deptno on dept(deptno);

 explain plan for select * from emp
select * from table(dbms_xplan.display());

################# 第七章 表设计优化#####################

##1范围分区
create table range_part_tab(
       id number not null primary key,
       deal_date date not null,
       area_code number(3) not null,
       contents varchar2(4000)
)
partition by range(deal_date)
(
          partition p1 values less than (to_date('2015-02-01','YYYY-MM-DD' )),
          partition p2 values less than (to_date('2015-03-01','YYYY-MM-DD')),
          partition p3 values less than (to_date('2015-04-01','YYYY-MM-DD')),
          partition p4 values less than (to_date('2015-05-01','YYYY-MM-DD')),
          partition p5 values less than (to_date('2015-06-01','YYYY-MM-DD')),
          partition p6 values less than (to_date('2015-07-01','YYYY-MM-DD')),
          partition p7 values less than (to_date('2015-08-01','YYYY-MM-DD')),
          partition p8 values less than (to_date('2015-09-01','YYYY-MM-DD')),
          partition p9 values less than (to_date('2015-10-01','YYYY-MM-DD')),
          partition p10 values less than (to_date('2015-11-01','YYYY-MM-DD')),
          partition p11 values less than (to_date('2015-12-01','YYYY-MM-DD')),
          partition p12 values less than (to_date('2016-01-01','YYYY-MM-DD')),
          partition p_max values less than (maxvalue)
);

insert into range_part_tab (id,deal_date,area_code,contents)  
select rownum ,
             to_date(to_char(sysdate-365,'J')+Trunc(Dbms_Random.value(0,356)),'J'),
             ceil(dbms_random.value(590,599)),
             rpad('*',400,'*')
from dual
connect by rownum <=100000    

insert into range_part_tab (id,deal_date,area_code,contents)  values(100003,to_date('2015-11-01','YYYY-MM-DD'),598,'*********');

select *   from range_part_tab partition(p1) ;

select * from range_part_tab
select count(1) from range_part_tab

##列表分区
create table list_part_tab(
       id number not null primary key,
       deal_date date not null,
       area_code number(3) not null,
       contents varchar2(4000)
)
partition by list(area_code)
(
          partition p_591 values (591),
          partition p_592 values (592),
          partition p_593 values  (593),
          partition p_594 values  (594),
          partition p_595 values  (595),
          partition p_596 values  (596),
          partition p_597 values  (597),
          partition p_598 values  (598),
          partition p_599 values  (599),
          partition p_other values (DEFAULT)
);

insert into list_part_tab (id,deal_date,area_code,contents)  
select rownum ,
             to_date(to_char(sysdate-365,'J')+Trunc(Dbms_Random.value(0,356)),'J'),
             ceil(dbms_random.value(590,599)),
             rpad('*',400,'*')
from dual
connect by rownum <=100000  

select *   from list_part_tab partition(p_592) ;

select *   from list_part_tab where area_code=592 ;
         
##比较
create table part_tab(
       id number not null primary key,
       deal_date date not null,
       area_code number(3) not null,
       contents varchar2(4000)
)

insert into part_tab (id,deal_date,area_code,contents)  
select rownum ,
             to_date(to_char(sysdate-365,'J')+Trunc(Dbms_Random.value(0,356)),'J'),
             ceil(dbms_random.value(590,599)),
             rpad('*',400,'*')
from dual
connect by rownum <=100000



explain plan for 
select *  from range_part_tab 
where deal_date >=to_date('2015-08-04','YYYY-MM-DD')
             and deal_date <=to_date('2015-08-07','YYYY-MM-DD')
             
select * from table(dbms_xplan.display());

explain plan for 
select *  from part_tab 
where deal_date >=to_date('2015-08-04','YYYY-MM-DD')
             and deal_date <=to_date('2015-08-07','YYYY-MM-DD')
             
select * from table(dbms_xplan.display());

######################第八章 索引######################
create table t1 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=1;
create table t2 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=10;
create table t3 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=100;
create table t4 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=1000;
create table t5 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=10000;
create table t6 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=100000;
create table t7 as select rownum as id,rownum+1 as id2,rpad('*',1000,'*') as contents from dual connect by level<=1000000;

create index idx_id_t1 on t1(id);
create index idx_id_t2 on t2(id);
create index idx_id_t3 on t3(id);
create index idx_id_t4 on t4(id);
create index idx_id_t5 on t5(id);
create index idx_id_t6 on t6(id);
create index idx_id_t7 on t7(id);

select * from t1
select * from t2
select * from t3
select * from t4
select * from t5
select * from t6
select * from t7 where id =1
select /*+full(t1)*/ * from t7 where id =1

select us.index_name,us.blevel,us.LEAF_BLOCKS,us.NUM_ROWS,us.DISTINCT_KEYS,us.CLUSTERING_FACTOR
 from user_ind_statistics us where us.table_name in('T1','T2','T3','T4','T5','T6','T7')
 
 
select * from DBA_TABLES


select * from (select r.*,rownum rn  from (select * from users) r where rownum<=4) a where a.rn>0
