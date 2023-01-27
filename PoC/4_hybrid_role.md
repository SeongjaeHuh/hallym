## 1. 공통
```
-- Role : hybrid, hybrid_dev
-- User : user_hybrid_admin, user_hybrid_dev

use role securityadmin;

create role hybrid; /*운영 CRUD + 개발 R*/
create role hybrid_dev; /* 개발 CRUD + 운영R*/


grant role hybrid to role sysadmin;
grant role hybrid_dev to role sysadmin;

```

## 2. 개발계 (hybrid_dev)
```
use role accountadmin;

-- hybrid_dev
-- 1.  (개발) hybrid_dev에 read/ins_del/create_objects 권한 주기
-- (1). HALLYM_DEV 권한 부여
grant usage on database HALLYM_DEV to role hybrid_dev;
grant usage on all schemas in database HALLYM_DEV to role hybrid_dev;
grant select on all tables in database HALLYM_DEV to role hybrid_dev;
grant select on all views in database HALLYM_DEV to role hybrid_dev;

grant usage on future schemas in database HALLYM_DEV to role hybrid_dev;
grant select on future tables in database HALLYM_DEV to role hybrid_dev;
grant select on future views in database HALLYM_DEV to role hybrid_dev;

grant insert, update, delete on all tables in database HALLYM_DEV to role hybrid_dev;
grant insert, update, delete on future tables in database HALLYM_DEV to role hybrid_dev;

grant 
 create table
,create view
,create file format
,create stage
,create pipe
,create sequence
,create function
,create procedure on all schemas in database HALLYM_DEV
to role hybrid_dev;

grant 
 create table
,create view
,create file format
,create stage
,create pipe
,create sequence
,create function
,create procedure on future schemas in database HALLYM_DEV
to role hybrid_dev;



--2. (운영) hybrid_dev 에 운영계 DB의 read 권한 주기
grant usage on database HALLYM to role hybrid_dev;
grant usage on all schemas in database HALLYM to role hybrid_dev;
grant select on all tables in database HALLYM to role hybrid_dev;
grant select on all views in database HALLYM to role hybrid_dev;

grant usage on future schemas in database HALLYM to role hybrid_dev;
grant select on future tables in database HALLYM to role hybrid_dev;
grant select on future views in database HALLYM to role hybrid_dev;




--3. (개발) hybrid_dev 에 warehouse usage, monitor권한 주기
grant usage on warehouse GUEST_WH to role hybrid_dev;
grant monitor on warehouse GUEST_WH to role hybrid_dev;
```

## User 생성
```
--신규 user를 user_hybrid_admin 이름으로 생성, 초기 패스워드는 'Qwer1234', 최초 로그인시 바꾸도록 설정
create user user_hybrid password = 'Qwer!1212' must_change_password = false;

--user_hybrid_admin에 hybrid Role을 부여 (hybrid, hybrid_dev 중 택 1)
grant role hybrid_dev to user user_hybrid;

--user_analyst에 기본 Role은 analyst로 부여
alter user user_hybrid set default_role = 'hybrid';

--user_hybrid_admin의 기본 warehouse는 GUEST_WH 설정
alter user user_hybrid set default_warehouse = 'GUEST_WH';
```

## Use hybrid Role
```
use role hybrid_dev;
use HALLYM.HALLYM;
select * from "HALLYM"."HALLYM"."HEALTH_CLINIC_DEPT";

--운영 (실패)
insert into "HALLYM"."HALLYM"."HEALTH_CLINIC_DEPT" values ('앙과','앙','꽈');
```

![image](https://user-images.githubusercontent.com/52474199/214993169-370a979e-0c2a-45ae-a5fb-f9320b188e67.png)

```
--개발 (성공)
use HALLYM_DEV.HALLYM_DEV;
insert into "HALLYM_DEV"."HALLYM_DEV"."HEALTH_CLINIC_DEPT" values ('앙과','앙','꽈');
```

![image](https://user-images.githubusercontent.com/52474199/214993408-5e706aae-afcc-4aab-8e83-bd4d7312a1b4.png)

## user_analyst : read all tables in hallym
![image](https://user-images.githubusercontent.com/52474199/215128546-e9aaa516-4f3b-4773-bfc4-153ed04f07f2.png)


## user_in_half : read only 2 tables in hallym
![image](https://user-images.githubusercontent.com/52474199/215128238-4be28aa9-fbaa-44db-a2df-a65fc35bddc3.png)

