## How to make a RBAC_GENERAL?

### 1. create a role (functional role & access role)

```sql
USE ROLE USERADMIN; 

--access_role
CREATE ROLE db_dr_r;
CREATE ROLE db_dr_rw;
CREATE ROLE db_dr_adm;

--functional role
CREATE ROLE analyst; --r
CREATE ROLE elt; --rw
CREATE ROLE dba; --adm

--grant to sysadmin 
grant role dba to role sysadmin;
grant role elt to role sysadmin;
grant role analyst to role sysadmin;

/* 권한확인 */
show grants to role read;
show grants;
show grants on account;
```

### 2. Grant **OWNERSHIP**(admin) on database [DB_NAME] to [ROLE_NAME] role.

```sql
USE ROLE SECURITYADMIN;
```

```sql
GRANT OWNERSHIP ON DATABASE [DB_NAME] TO ROLE db_dr_adm;
GRANT ALL PRIVILEGES ON DATABASE [DB_NAME] TO ROLE db_dr_adm;
```

### 3.(1) Grant **READ-ONLY** permissions on database [DB_NAME] to [ROLE_NAME] role.
```sql
GRANT USAGE ON DATABASE [DB_NAME] TO ROLE db_dr_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE [DB_NAME] TO ROLE db_dr_r;

GRANT USAGE ON ALL STAGES IN DATABASE [DB_NAME] TO ROLE db_dr_r;
GRANT USAGE ON ALL FILE FORMATS IN DATABASE [DB_NAME] TO ROLE db_dr_r;

GRANT SELECT ON ALL TABLES IN DATABASE [DB_NAME] TO ROLE db_dr_r;
GRANT SELECT ON ALL VIEWS IN DATABASE [DB_NAME] TO ROLE db_dr_r;
```

### 3.(2) read role에 앞으로 생성될 table, view에 대해서 select 권한 부여

```sql
grant usage on future schemas in database [DB_NAME] to role db_dr_r;

GRANT USAGE ON FUTURE STAGES IN DATABASE [DB_NAME] TO ROLE db_dr_r;
GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE [DB_NAME] TO ROLE db_dr_r;

grant select on future tables in database [DB_NAME] to role db_dr_r;
grant select on future views in database [DB_NAME] to role db_dr_r;
```

### 4.(1) Grant **READ_WRITE** permissions on database [DB_NAME] to [ROLE_NAME] role.
```sql
GRANT USAGE ON DATABASE [DB_NAME] TO ROLE db_dr_rw;
GRANT USAGE ON ALL SCHEMAS IN DATABASE [DB_NAME] TO ROLE db_dr_rw;
GRANT SELECT,INSERT,UPDATE,DELETE,TRUNCATE ON ALL TABLES IN DATABASE [DB_NAME] TO ROLE db_dr_rw;
```
### 4.(2) read role에 앞으로 생성될 table, view에 대해서 select 권한 부여
```sql
grant SELECT,INSERT,UPDATE,DELETE,TRUNCATE on future tables in database [DB_NAME] to role db_dr_rw;
grant SELECT,INSERT,UPDATE,DELETE,TRUNCATE on future views in database [DB_NAME] to role db_dr_rw;
```

### 5. Make a Role Hierarchy
```sql
GRANT ROLE db_dr_r TO ROLE db_dr_rw;
GRANT ROLE db_dr_rw TO ROLE db_dr_adm;
```

### 6. Mapping [access_role] to [functional_role].
```sql
GRANT ROLE db_dr_r TO ROLE analyst; --ro
GRANT ROLE db_dr_rw TO ROLE elt; --rw
GRANT ROLE db_dr_adm TO ROLE dba; --admin
```

### 7. Make a common role
```sql
GRANT USAGE ON WAREHOUSE XS_WH TO ROLE sysadmin;
grant usage on warehouse compute_wh to role db_dr_r;
grant monitor on warehouse compute_wh to role elt;

```

### 8. ownership 변경
clone copy 로 작업했기 때문에 기존 owner인 etl만 drop (create table 권한)이 가능함. 이에 따라 아래와 같이 소유자를 etl로 이관해 줌.

```sql
grant ownership on all tables in schema crawl.rsn to role elt copy current grants;
grant ownership on all tables in schema crawl.sensortower to role elt copy current grants;
grant ownership on all tables in schema crawl.steamspy to role elt copy current grants;

--소유권 변경(accountadmin to sysadmin)
GRANT OWNERSHIP ON DATABASE [DB_NAME] TO ROLE SYSADMIN;
GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE [DB_NAME] TO ROLE SYSADMIN;
GRANT OWNERSHIP ON ALL tableS IN DATABASE [DB_NAME] TO ROLE SYSADMIN;

--get_ddl로 원본 ddl 확인
select get_ddl ('table','"CRAWL"."RSN"."GOV_TEST_EPIC7_20230102"');
```

### cf) naming rule(db명을 사번으로 하는 것 고려)
```sql
a_[DB_NAME]_analyst
a_[DB_NAME]_elt
a_[DB_NAME]_admin
```
