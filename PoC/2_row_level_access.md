# Row Level ACCESS POLICY in Snowflake

## 1. Concept of Row-Based Security
> Row-level security, or row-based security, is a data access control concept in which access to data in a table is limited according to certain restrictions, and various users, groups or roles may have different permissions on certain rows, based on identitiesQ within the rows.

![image](https://user-images.githubusercontent.com/52474199/184362707-38e93778-8da3-476c-bc16-6a7de6990c6a.png)


## 2. Create Sample Table

### 2.1. Create table HEART_CLONE by using copy clone.
```sql
/*
create database sec;
create schema sec;
create table HEART_CLONE clone HEART;
*/

create or replace TABLE HEART_CLONE (
	ID NUMBER(38,0),
	AGE NUMBER(38,0),
	SEX NUMBER(38,0),
	CP NUMBER(38,0),
	TRESTBPS NUMBER(38,0),
	CHOL NUMBER(38,0),
	FBS NUMBER(38,0),
	RESTECG NUMBER(38,0),
	THALACH NUMBER(38,0),
	EXANG NUMBER(38,0),
	OLDPEAK FLOAT,
	SLOPE NUMBER(38,0),
	CA NUMBER(38,0),
	THAL NUMBER(38,0),
	TARGET NUMBER(38,0)
) 
;
```

### 2.2. Make the Dupl. Data
```sql
INSERT INTO HEART_CLONE (
  SELECT ID + 3000, /*300 x 10번 증가 */
         AGE, SEX, CP, TRESTBPS, CHOL, FBS, RESTECG, THALACH, EXANG, OLDPEAK, SLOPE, CA, THAL, TARGET
    FROM HALLYM.HALLYM.HEART 
   WHERE ID < 10301 );
   
```
### 2.3. Alter Table (ADD) DEPT COLUMN 
```sql
ALTER TABLE HEART_CLONE add column DEPT varchar(24) NULL;
```

### 2.4. DEPT COLUMN DATA 입력 (5개 진료부서)
```sql
UPDATE HEART_CLONE
SET DEPT = CASE WHEN MOD(id, 5) = 0 THEN 'FM' /* Family Medicine 가정의학과 */
                WHEN MOD(id, 5) = 1 THEN 'ED' /* Endocrinology 내분비내과 */
                WHEN MOD(id, 5) = 2 THEN 'NS' /* Neuro-Surgery 신경외과 */
                WHEN MOD(id, 5) = 3 THEN 'DM' /* Dermatology 피부과 */
ELSE 'CV' /* cardiovascular medicine(cardium-heart, vascular-vessel) 심장내과 */
END;
```

### 2.5. (Done) SAMPLE TABLE (데이터 3000건으로 증가, 부서코드 추가)
![image](https://user-images.githubusercontent.com/52474199/211752516-aa3a9132-ca28-4db9-8623-079dc6f9ff00.png)

### 2.6. ID 중복 건 확인
```sql
SELECT * 
  FROM
       (
         SELECT ROW_NUMBER() OVER (PARTITION BY ID ORDER BY FBS DESC) RN, X.* 
           FROM (SELECT * 
                   FROM HEART_CLONE) X
  
        ) Y
 WHERE Y.RN > 1;
```
![image](https://user-images.githubusercontent.com/52474199/211753723-2289545d-22fc-4b16-9bac-ab53ca8709c1.png)




## 3. Make a Row-Level Access Control

### Step 1: Create a Row-Level Security Configuration Table
> We are creating a table that will contain the mapping of roles to DEPT.

```
CREATE TABLE dept_entitlements (role_entitled string, dept string); 
INSERT INTO dept_entitlements VALUES ('USER_FM', 'FM'), ('USER_ED', 'ED'), ('USER_NS', 'NS'), ('USER_DM', 'DM'), ('USER_CV', 'CV');
```
![image](https://user-images.githubusercontent.com/52474199/211759993-6fa7596e-bbc6-4508-9967-bfd8d1c6c155.png)


###  Step 2: Create the Row Access Policy
> In Role DEPT_ADMIN, they will see all Data, regardless of Dept.  
> However, other roles will be looked up in the mapping table, to check if the current role can view data from the specific Dept:

```sql
CREATE ROW ACCESS POLICY dept_access  AS (dept_filter VARCHAR) 
 RETURNS BOOLEAN -> CURRENT_ROLE() = 'DEPT_ADMIN' 
 OR EXISTS (
             SELECT 1 FROM dept_entitlements   
              WHERE dept = dept_filter 
                AND role_entitled = CURRENT_ROLE()
            );
```

### Step 3: Apply the Access Policy.
> The dept_access policy apply on the dept column of HEART_CLONE.

```sql
ALTER TABLE HEART_CLONE ADD ROW ACCESS POLICY dept_access ON (dept);
```

### Step 4: Create & Granting Permissions on Role

```sql
use role accountadmin;

-- create new roles
CREATE ROLE DEPT_ADMIN;
CREATE ROLE USER_FM;
CREATE ROLE USER_ED;
CREATE ROLE USER_NS;
CREATE ROLE USER_DM;
CREATE ROLE USER_CV;

-- object usage permission on DEPT_ADMIN
grant usage on database sec to role DEPT_ADMIN;
grant usage on all schemas in database sec to role DEPT_ADMIN;
grant select,update,delete on all tables in database sec to role DEPT_ADMIN;
grant select,update,delete on all views in database sec to role DEPT_ADMIN;

-- object usage permission on USER_FM
grant usage on database sec to role USER_FM;
grant usage on all schemas in database sec to role USER_FM;
grant select on all tables in database sec to role USER_FM;
grant select on all views in database sec to role USER_FM;

-- object usage permission on USER_ED
grant usage on database sec to role USER_ED;
grant usage on all schemas in database sec to role USER_ED;
grant select on all tables in database sec to role USER_ED;
grant select on all views in database sec to role USER_ED;

-- object usage permission on USER_NS
grant usage on database sec to role USER_NS;
grant usage on all schemas in database sec to role USER_NS;
grant select on all tables in database sec to role USER_NS;
grant select on all views in database sec to role USER_NS;

-- object usage permission on USER_DM
grant usage on database sec to role USER_DM;
grant usage on all schemas in database sec to role USER_DM;
grant select on all tables in database sec to role USER_DM;
grant select on all views in database sec to role USER_DM;

-- object usage permission on USER_CV
grant usage on database sec to role USER_CV;
grant usage on all schemas in database sec to role USER_CV;
grant select on all tables in database sec to role USER_CV;
grant select on all views in database sec to role USER_CV;

/* -- permission on future objects
grant usage on future schemas in database sec to role DEPT_ADMIN;
grant select on future tables in database sec to role DEPT_ADMIN;
grant select on future views in database sec to role DEPT_ADMIN;
*/

-- warehouse usage permission
grant usage on warehouse compute_wh to role DEPT_ADMIN;
grant usage on warehouse compute_wh to role USER_FM;
grant usage on warehouse compute_wh to role USER_ED;
grant usage on warehouse compute_wh to role USER_NS;
grant usage on warehouse compute_wh to role USER_DM;
grant usage on warehouse compute_wh to role USER_CV;
```

### Step5. Create a User & Grant Role

```sql
create user user_sec password = 'Qwer!1212' must_change_password = false;

--user_analyst에 analyst Role을 부여 (dba, elt, dev, analyst 중 택 1)
grant role analyst to user user_sec;

--user_analyst에 기본 Role은 analyst로 부여
alter user user_sec set default_role = 'ANALYST';

--user_analyst의 기본 warehouse는 compute_wh로 설정
alter user user_sec set default_warehouse = 'compute_wh';

-- grant role to the_user_we_want_to_assign                                                
GRANT ROLE DEPT_ADMIN TO USER user_sec;
GRANT ROLE USER_FM TO USER user_sec;
GRANT ROLE USER_ED TO USER user_sec;
GRANT ROLE USER_NS TO USER user_sec;
GRANT ROLE USER_DM TO USER user_sec;
GRANT ROLE USER_CV TO USER user_sec;

```

### Results
> DEPT_ADMIN, they will see all data, regardless of dept. 
```sql
USE ROLE DEPT_ADMIN;
SELECT * FROM HEART_CLONE;
SELECT count(*) FROM HEART_CLONE;
```
![image](https://user-images.githubusercontent.com/52474199/211750406-8b2114f6-e4d3-4c47-8be5-2fdc58789b5d.png)
![image](https://user-images.githubusercontent.com/52474199/211749496-64a5a4a6-a699-4c14-9e15-c8e0e668ec61.png)

> the USER_FM role can view data only in FM Dept.
```sql
USE ROLE USER_FM;
SELECT * FROM HEART_CLONE;
SELECT count(*) FROM HEART_CLONE;
```
![image](https://user-images.githubusercontent.com/52474199/211749762-f070d312-f5c5-47d8-85bf-e4fc5a8decb1.png)
![image](https://user-images.githubusercontent.com/52474199/211749830-4a02e4c0-755e-482a-b206-0dc60088020c.png)


> the USER_ED role can view data only in ED Dept.
```sql
USE ROLE USER_ED;
SELECT * FROM HEART_CLONE;
SELECT count(*) FROM HEART_CLONE;
```
![image](https://user-images.githubusercontent.com/52474199/211750207-0502cd32-607d-4e5d-8b56-af82f147a17a.png)
![image](https://user-images.githubusercontent.com/52474199/211749830-4a02e4c0-755e-482a-b206-0dc60088020c.png)

[참고](https://blog.satoricyber.com/snowflake-row-level-sec/)
