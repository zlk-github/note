
### 1 oracle10g登录命令
 
配置文件：\network\admin\tnsnames.ora
 
1.1登录数据库

    超级用户：
	conn  system/manager  as sysdba;
	普通用户：
	conn zhoulk/zhoulk;  --conn scott/tiger;


1.2创建数据表空间

	create tablespace 表空间  
	logging  
	datafile 'Q:\oracle\product\10.2.0\oradata\Test\xyrj_data.dbf' 
	size 50m  
	autoextend on  
	next 50m maxsize 20480m  
	extent management local;  
 
1.3创建用户并指定表空间

	create user 用户名 identified by 密码  
	default tablespace 表空间  
	temporary tablespace user_temp;

1.4给用户授予权限

	grant connect,resource,dba to 用户名;


	
	2）sqlplus / as sysdba 或者 sqlplus sys/密码 as sysdba
	3) create user 用户名 identified by 密码;
	4) grant connect,resource to 用户名;
	5) conn 用户名/密码