# Snowflake 보안 구조

![image](https://user-images.githubusercontent.com/52474199/186452235-616d7cdc-a2dc-4036-b946-d6b8746fc649.png)

![image](https://user-images.githubusercontent.com/52474199/186452768-273de31a-6cf8-4f69-96ff-117793e221b9.png)

![image](https://user-images.githubusercontent.com/52474199/186452555-2bf9adf4-ceef-401b-8dcf-f364b081e1a8.png)

![image](https://user-images.githubusercontent.com/52474199/186452611-6f378f63-4ed6-47a8-b891-dad7870df264.png)



## 1. 사용자 권한 생성

### (1). 기능 role 생성
```
use role securityadmin;
create role dba;
create role elt;
create role dev;
create role analyst;
```

### (2). 상위 role에 계층 구조 생성
```
grant role dba to role sysadmin;
grant role elt to role sysadmin;
grant role dev to role sysadmin;
grant role analyst to role sysadmin;
```

### (3). 접근 권한 설정을 위한 role 생성
```
use role securityadmin;
create role read;
create role ins_del;
create role create_objects;
create role manage_db;
create role warehouse_monitor;
```
```
/* 권한확인 */
show grants to role read;
show grants;
show grants on account;
```

### (4). 권한 role 계층구조 생성

![image](https://user-images.githubusercontent.com/52474199/186463114-5aa09cb1-bfb6-4cae-93da-be52b2eb40de.png)

```
grant role read to role ins_del;
grant role ins_del to role create_objects;
grant role create_objects to role manage_db;
```
```
--
/*권한확인*/
show grants to role ins_del;
show grants to role create_objects;
show grants to role manage_db;
```

### (5). 권한 role을 기능 role에 계층화

```
grant role read to role analyst;
grant role ins_del to role dev;
grant role create_objects to role elt;
grant role manage_db to role dba;

-- GRANT ROLE "ELT" TO ROLE "DBA"; /* ELT 에서 만든 SP가 DBA 로 접속시 안보였을 때 사용*/
```
```
show grants to role analyst;
show grants to role dev;
show grants to role elt;
show grants to role dba;
```


## 2. database 생성 및 관련 object에 권한 부여

```
use role sysadmin;
create or replace database tcmsdb; /*DB 생성*/
CREATE SCHEMA "tcmsdb"."ETLIF";  /*SCHEMA 생성*/

/* select get_ddl('table','dip.dw.etl_history'); --DDL 조회 */
/* 
create or replace TABLE ETL_HISTORY (
	DATE DATE,
	DAG_ID VARCHAR(16777216),
	STATUS VARCHAR(16777216),
	SOURCE_NAME VARIANT,
	TARGET_NAME VARIANT,
	SOURCE_COUNT NUMBER(38,0),
	ROW_COUNT VARIANT,
	TOTAL_ROW_COUNT NUMBER(38,0),
	FILE_SIZE VARIANT,
	TOTAL_FILE_SIZE NUMBER(38,0),
	ERROR_CODE NUMBER(38,0),
	ERROR_MESSAGE VARCHAR(16777216),
	START_TIME TIMESTAMP_NTZ(9),
	END_TIME TIMESTAMP_NTZ(9),
	DURATION_SEC NUMBER(38,0)
);
*/
```

### (1). read role에 usage 권한 부여 (read role에 부여하면 상위 role에도 자동 적용됨)
```
use role sysadmin;
grant usage on database tcmsdb to role read;
grant usage on all schemas in database tcmsdb to role read;
grant select on all tables in database tcmsdb to role read;
grant select on all views in database tcmsdb to role read;
```
### (2). read role에 앞으로 생성될 table, view에 대해서 select 권한 부여 (상위 모든 role이 해당 권한을 가짐)

```
use role accountadmin; -- sysadmin: SQL access control error: Insufficient privileges to operate on database 'TCMSDB'
grant usage on future schemas in database tcmsdb to role read;
grant select on future tables in database tcmsdb to role read;
grant select on future views in database tcmsdb to role read;
```

### (3). ins_del role에 insert, update, delete 권한 부여
```
grant insert, update, delete on all tables in database tcmsdb to role ins_del;
grant insert, update, delete on future tables in database tcmsdb to role ins_del;
```

### (4). create_objects role에 create 권한 부여
```
grant 
 create table
,create view
,create file format
,create stage
,create pipe
,create sequence
,create function
,create procedure on all schemas in database tcmsdb
to role create_objects;
```
```
grant 
 create table
,create view
,create file format
,create stage
,create pipe
,create sequence
,create function
,create procedure on future schemas in database tcmsdb
to role create_objects;
```
### (5). warehouse 권한 부여
```
grant usage on warehouse compute_wh to role read;
grant monitor on warehouse compute_wh to role dev;
```

### (6). database 관리 권한 부여
```
grant 
modify, monitor, create schema on database tcmsdb
to role manage_db;
```
