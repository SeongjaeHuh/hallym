# Dyanmic Masking in Snowflake

## What is Dynamic Data Masking
> Dynamic Data Masking is a Column-level Security feature that uses masking policies to selectively mask plain-text data in table and view columns at query time.

## What is Masking Policies?
> Snowflake supports masking policies as a schema-level object to protect sensitive data from unauthorized access.
> Sensitive data in Snowflake is not modified in an existing table.

![image](https://user-images.githubusercontent.com/52474199/184530464-2a5b059b-b91a-408d-a8fe-bee4006f6109.png)

![image](https://user-images.githubusercontent.com/52474199/184530848-c7c9ab90-2212-4f6f-b0f1-fe4fac5e948d.png)

### Step 1: Create Sample Table
```sql
create database dynamic_masking;
create schema dynamic_masking;
create or replace TABLE EMPLOYEES (
	EMPLOYEEID NUMBER(38,0),
	FULLNAME VARCHAR(30),
	BIRTHDATE DATE,
	Email VARCHAR(30),
	POSITION VARCHAR(30),
	DEPARTMENT VARCHAR(30),
	USERPASSWORD VARCHAR(30)
) COMMENT='MaskingTest'
```
![image](https://user-images.githubusercontent.com/52474199/184528926-fd748cec-828a-4f9f-a999-95cd4f525e19.png)


### Insert Sample Data
```sql
INSERT into Employees VALUES 
(1000,'John','19550219','john@test.tt','CEO','Administration','2414199323'), 
(1001,'Daniel','19831203','daniel@test.tt','Programmer','IT','3978899323'), 
(1002,'Mike','19760607','mike@test.tt','Accountant','Account dept','9874122323'), 
(1003,'Jordan','19820417','jordan@test.tt','Senior programmer','IT','6678889323'),
(1004,'Kavin','19550498','kevin@test.tt','CFO','Administration',''),
(1005,'','19558497','david@test.tt','CTO','Administration','4628889323');
```
![image](https://user-images.githubusercontent.com/52474199/184528970-2bca82f2-ecac-4cbc-9da8-c575d29ceca0.png)


### Step 2: Create the Column Masking Policy

#### leave email domain unmasked to role SUPPORT
```sql
create or replace masking policy email_mask as (val string) returns string ->
case
  when current_role() in ('ANALYST') then val
  when current_role() in ('SUPPORT') then regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  else '********'
end;
```
![image](https://user-images.githubusercontent.com/52474199/184529108-464282a3-330a-4b17-9bc5-dc87b70fffc1.png)

#### making masking policy except ANALYST
```sql
create or replace masking policy position_mask as (val string) returns string ->
  case
    when current_role() in ('ANALYST') then val
    else '*********'
  end;
```
![image](https://user-images.githubusercontent.com/52474199/184529133-ba761ca4-a141-4253-8b10-9a1791a36d0f.png)


#### return hash of the column value to role SUPPORT
```sql
create or replace masking policy userpassword_mask as (val string) returns string ->
case
  when current_role() in ('ANALYST') then val
  else sha2(val) -- return hash of the column value
end;
```
![image](https://user-images.githubusercontent.com/52474199/184529155-74fcd00f-5054-459a-b194-438741d40dd8.png)

#### making no masking policy to role SUPPORT
```sql
create or replace masking policy fullname_mask as (val string) returns string ->
  case
    when current_role() in ('SUPPORT') then val
    else '*********'
  end;
```

![image](https://user-images.githubusercontent.com/52474199/184529168-63d8ca2f-e80e-4274-aa70-bb7576115be4.png)



### Step 3: Apply the Access Policy
```sql
use role accountadmin;
alter table if exists EMPLOYEES modify column email set masking policy email_mask;
alter table if exists EMPLOYEES modify column position set masking policy position_mask;
alter table if exists EMPLOYEES modify column userpassword set masking policy userpassword_mask;
alter table if exists EMPLOYEES modify column fullname set masking policy fullname_mask;
```
### Step 4: Create & Granting Permissions on Role (Analyst, Support)
```sql
CREATE ROLE ANALYST;
CREATE ROLE SUPPORT;

-- grant role to the_user_we_want_to_assign
GRANT ROLE ANALYST TO USER SFADMIN;
GRANT ROLE SUPPORT TO USER SFADMIN;

-- object usage permission on ANALYST
grant usage on database DYNAMIC_MASKING to role ANALYST;
grant usage on all schemas in database DYNAMIC_MASKING to role ANALYST;
grant select,update,delete on all tables in database DYNAMIC_MASKING to role ANALYST;
grant select,update,delete on all views in database DYNAMIC_MASKING to role ANALYST;

-- object usage permission on SUPPORT
grant usage on database DYNAMIC_MASKING to role SUPPORT;
grant usage on all schemas in database DYNAMIC_MASKING to role SUPPORT;
grant select,update,delete on all tables in database DYNAMIC_MASKING to role SUPPORT;
grant select,update,delete on all views in database DYNAMIC_MASKING to role SUPPORT;

-- warehouse usage permission
grant usage on warehouse compute_wh to role ANALYST;
grant usage on warehouse compute_wh to role SUPPORT;
```

#### (cf) Grantig masking policy to role support

```sql
use role accountadmin;

-- Grantig masking policy to role support
grant create masking policy on schema <schema_name> to role support;
```


### 5. Result

#### (1). All Data with No Masking
![image](https://user-images.githubusercontent.com/52474199/163592996-3f8c14bf-d769-41eb-a5de-c4bd63f62167.png)

#### (2). Use Role ANALYST (MASKING @fullname) - null with masking
```sql
use role ANALYST;
SELECT * FROM EMPLOYEES;
```
![image](https://user-images.githubusercontent.com/52474199/163595325-5532744b-e4ac-4c1f-b261-ea646a4048ca.png)

#### (3). Use Role SUPPORT (r.e.@email, masking@position, hashing@userpassword)
```sql
use role SUPPORT;
SELECT * FROM EMPLOYEES;
```
![image](https://user-images.githubusercontent.com/52474199/163595052-e670d3fc-c905-4527-ad5e-5eb7edc96ca6.png)

#### (4).  Use Role ETC (MASKING @fullname, @email, @position, @department)
```sql
use role sysadmin;
SELECT * FROM EMPLOYEES;
```
![image](https://user-images.githubusercontent.com/52474199/163594563-f1d99ff7-c9b2-49bd-a740-1d2a5626a0ea.png)


## Conclusion
> we demonstrated how you can simplify the management of row-level security for fine-grained access control of your sensitive data building on the foundation of role-based access control. 
> Snowflake supports row-level, column-level, and cell-level access control for data stored in Storage.

[참고](https://docs.snowflake.com/en/user-guide/security-column-intro.html#how-does-a-masking-policy-work)
