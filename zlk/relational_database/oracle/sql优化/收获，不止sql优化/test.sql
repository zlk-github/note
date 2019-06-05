#########################收获，不止sql优化###################################

########################第八章 索引优化######################################

##3索引本身有序之order by

  drop index idx1_t7_id2
  
  select *  from t7 order by id2 --27.176s
  select id2 from t7  order by id2 --12.356s
  select id,id2 from t7 order by id2 --11.529s
  select * from t7 where id2 >0 order by id2 --27.3s
  select * from t7 where id2 >0 and id2<10000 order by id2 --12.012
  select * from t7 where id2=3 order by id2 --12.3s
	 
	create index idx1_t7_id2 on t7(id2)
  
	select * from t7  order by id2  --25.586s
  select id2 from t7  order by id2 --0.452s
  select id,id2 from t7 order by id2 --11.435s
  select * from t7 where id2 >0 and id2<1000000 order by id2 --0.032s
  select * from t7 where id2 =3 order by id2 --0.031s

##4索引有序优化max与min

drop index idx1_t7_id2 
  
select max(id2) from t7   --12.309s
select min(id2) from t7   --12.169s
select max(id2),min(id2) from t7   --12.465s
select a.max,b.min from (select max(id2) max from t7) a,(select min(id2) min from t7 ) b --22.573s

create index idx1_t7_id2 on t7(id2)
  
select max(id2) from t7 --0.608s
select min(id2) from t7   --0.436s
select max(id2),min(id2) from t7   --1.279s
select a.max,b.min from (select max(id2) max from t7) a,(select min(id2) min from t7 ) b --0.031

## 5分页索引优化
drop index idx_id_id2;

select count (*) from t7  --12.136s
select count (*) from t7 where id>20 and id<20000 --0.473s
select count (1) from t7 --11.778s
select count (id2) from t7 --0.472s

select * from (select r.*,rownum rn  from (select * from t7) r where rownum<=10) a where a.rn>0 --0.031s
select * from (select r.*,rownum rn  from (select * from t7) r where rownum<=900010 ) a where a.rn>900000 --10.92s
select * from (select r.*,rownum rn  from (select id,id2 from t7 ) r where rownum<=900010  ) a where a.rn>900000--10.655s

create index idx_id_id2 on t7(id,id2);

select * from (select r.*,rownum rn  from (select * from t7) r where rownum<=10) a where a.rn>0 --0.031s
select * from (select r.*,rownum rn  from (select * from t7 ) r where rownum<=900010 ) a where a.rn>900000 --9.92s
select * from (select r.*,rownum rn  from (select id,id2 from t7 ) r where rownum<=900010  ) a where a.rn>900000--1.046s



select * from  t7 where id2>20 and id2<21 and id>1; --0.764s
select * from  t7 where id2 in(20,21) and id>1; --0.187s

## 6 组合索引

create table t as select * from dba_objects; 
select * from t  --50912行

drop index idx_id_type;
drop index idx_type_id;

select * from t where  object_id=20  and object_type='TABLE'; --0.031s
select * from  t where object_id>20 and object_id<2000 and object_type='TABLE'; --0.047s

create index idx_id_type on t(object_id,object_type);

select * from t where  object_id=20  and object_type='TABLE'; --0.031s
select * from  t where object_id>20 and object_id<2000 and object_type='TABLE'; --0.047s


drop index idx_type_id;
select * from  t where object_id>20 and object_id<21 and object_type='TABLE'; --0.015s
select * from  t where object_id in(20,21) and object_type='TABLE'; --0.032s

create index idx_type_id on t(object_type,object_id);

select * from  t where object_id>20 and object_id<200000 and object_type='TABLE'; 

select * from  t where object_id>20 and object_id<21 and object_type='TABLE'; --0.015s
select * from  t where object_id in(20,21) and object_type='TABLE'; --0.032s


select * from (select r.*,rownum rn  from (select * from t ) r where rownum<=50010  ) a where a.rn>50000
####################################执行计划，和统计信息####################
##执行计划
explain plan for select * from t 

select * from table(dbms_xplan.display());

## 统计信息
select * from t 

select *  from v$sql where sql_text like '%select * from t %';

## 通过sqlID
select * from table(dbms_xplan.display_cursor('6qu70hus7qc3x',0,'allstats last'))

############################################################################

#######################第十一章 表连接 、 第十二章 等价改写###########################

##表准备

##学生表
create table student(
       id integer  not null primary key, -- 主键id,学号
       s_name varchar2(100) not null, --姓名
       birthday date not null, --生日
       sex integer  default  1, --1男，2女
       s_desc varchar2(1000) --描述
)

select count(1) from student t

select * from student t

delete from student

insert into student values(1,'Tom', to_date ( '2007-11-15' , 'YYYY-MM-DD' ),1,'miaoshu' )
##课程表
create table course(
       id integer not null primary key, -- 主键id
       c_name  varchar2(100)  not null  --课程名称
)

## 选修成绩表
create table Grade(
       s_id integer not null , -- 学号
       c_id integer not null, -- 课程id
       score  number(4,1) , --成绩
       primary key(s_id,c_id)
)

##########################################################################
create table grade_table2(
       id integer not null , 
       s_id integer not null , -- 学号
       c_name varchar2(50)  not null, -- 课程名称
       score  number(4,1) , --成绩
       primary key(id)
)



insert into grade_table2(id,s_id,c_name,score) values(1001,20141001,'语文',90);
insert into grade_table2(id,s_id,c_name,score)  values(1002,20141001,'英语',85);
insert into grade_table2(id,s_id,c_name,score)  values(1003,20141001,'数学',70);

insert into grade_table2(id,s_id,c_name,score)  values(1004,20141002,'语文',80);
insert into grade_table2(id,s_id,c_name,score)  values(1005,20141002,'英语',98);
insert into grade_table2(id,s_id,c_name,score)  values(1006,20141002,'数学',77);

select  s_id 学号,
             MAX(case  when c_name= '语文' then  score ELSE 0 END) 语文,
             MAX(case  when c_name= '数学' then  score ELSE 0 END) 数学,
             MAX(case  when c_name= '英语' then  score ELSE 0 END) 英语  
 from grade_table2  GROUP BY s_id 
 
 select       s_id 学号,
              MAX(case  when c_name='语文'  then (case when   score>=90 then '优秀' when score>=80 then '良好' when score>=70 then '中等' when score>=60 then '及格'  else '不及格' end)  else '' end) 语文,
              MAX(case  when c_name='数学'  then (case when   score>=90 then '优秀' when score>=80 then '良好' when score>=70 then '中等' when score>=60 then '及格'  else '不及格' end)  else '' end) 数学,
              MAX(case  when c_name='英语' then  (case when   score>=90 then '优秀' when score>=80 then '良好' when score>=70 then '中等' when score>=60 then '及格'  else '不及格' end)  else '' end)  英语  
 from grade_table2  GROUP BY s_id 


select * from grade_table2 


create table grade_table(
       id integer not null , 
       chinese  number(4,1) not null , --中文成绩
       english  number(4,1) not null , -- 英语成绩
       math  number(4,1) not null  , --数学成绩
       primary key(id)
)

insert into grade_table(id,chinese,english,math) values(1001,90,80,60);
insert into grade_table(id,chinese,english,math) values(1002,91,70,59);

select 
id,
case  when chinese>=90 then '优秀' when chinese>=80 then '良好' when chinese>=70 then '中等' when chinese>=60 then '及格'  else '不及格' end as 语文,
case  when english>=90 then '优秀' when english>=80 then '良好' when english>=70 then '中等' when english>=60 then '及格'  else '不及格' end as 英语,
case  when math>=90 then '优秀' when math>=80 then '良好' when math>=70 then '中等' when math>=60 then '及格'  else '不及格' end as 数学
from grade_table




create sequence stu_squ
minvalue 1
maxvalue 20000000
start with 1
increment by 1
nocache;

drop sequence    stu_squ






