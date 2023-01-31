# 다기관 데이터 공유 Architecture
> 한림대, 강릉아산, 울산대 Data 통합 using by Snowflake Ext table & Data Sharing


![image](https://user-images.githubusercontent.com/52474199/214791755-6b11903f-1ce9-4ec0-8979-f941decdcf70.png)

## 작업방법
### 1. (한림대) 내부 Table 생성 후 적재
### 2. (강릉아산, 울산대) 병원별 Data S3 저장
### 3. (한림대) 병원별 Data Ext. Table 생성 
### 4. 통합 내부 Table + Ext. Table 통합 생성 후 Share to (강릉아산), (울산대)

***

## Step 1 응급실 중환자 심정지 예측을 위한 Data Split
> 총 : 230,449 건 (한림대 : 90,449 / 강릉아산, 울산대 : 각 70,000)
> 
## Step 2. 한림대 Table Loading
> 90,449 건


### 1. CPR Table 생성 

```sql
create schema hallym.share;

create or replace TABLE "INT_CPR_1" (
	"작성시간" VARCHAR(20),
	__RRT NUMBER(38,0),
	__TOT_4 NUMBER(38,0),
	__TOT_5 NUMBER(38,0),
	__TOT_6 NUMBER(38,0),
	__TOT_7 NUMBER(38,0),
	"호흡수" VARCHAR(5),
	"__호흡점수" VARCHAR(5),
	"산소포화도" VARCHAR(5),
	"__산소포화도점수" NUMBER(38,0),
	"__체온" VARCHAR(5),
	"__체온점수" NUMBER(38,0),
	"__혈압H" VARCHAR(5),
	"__혈압점수" NUMBER(38,0),
	"맥박" VARCHAR(5),
	"__맥박점수" NUMBER(38,0),
	"__의식변화" NUMBER(38,0),
	"__산소처방유무" NUMBER(38,0),
	"__RRT유무" NUMBER(38,0),
	AGE60 NUMBER(38,0),
	AGE70 NUMBER(38,0),
	"호흡점수v2" NUMBER(38,0),
	"산소포화도점수v2" NUMBER(38,0),
	"체온점수v2" NUMBER(38,0),
	"혈압점수v2" NUMBER(38,0),
	"맥박점수v2" NUMBER(38,0),
	"v2대상자" NUMBER(38,0),
	"최종대상자" NUMBER(38,0)
)COMMENT='수치형 응급실 중환자 심정지 AI 예측'
;
```

### 2. Stage 생성 (H2, 6/)

> Snowflake Stages are locations where data files are stored (“staged”) which helps in loading data into and unloading data out of database tables. The stage locations could be internal or external to Snowflake environment.

[More About Stage](https://thinketl.com/types-of-snowflake-stages-data-loading-and-unloading-features/)

```sql
CREATE STAGE hallym_stage URL = 's3://hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = 'AKIAWVIB7Z6F34RMP5==' AWS_SECRET_KEY = 'QuGf59LG5Z8o2+7r0Mr7vVc4Fm3NRlb3inSEGF==');
CREATE STAGE gnah_stage URL = 's3://asan-hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = 'AKIAWVIB7Z6F34RMP5==' AWS_SECRET_KEY = 'QuGf59LG5Z8o2+7r0Mr7vVc4Fm3NRlb3inSEGF==');
CREATE STAGE ulsan_stage URL = 's3://ulsan-hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = 'AKIAWVIB7Z6F34RMP5==' AWS_SECRET_KEY = 'QuGf59LG5Z8o2+7r0Mr7vVc4Fm3NRlb3inSEGF==');
```

### 3. File Format 생성
> describes a set of staged data to access or load into Snowflake tables.

```sql
CREATE FILE FORMAT "HALLYM"."SHARE".NULLABLE_CSV_FORMAT 
   COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' 
   SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' TRIM_SPACE = FALSE
   ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134' 
   DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('NULL');
```


### 4. TABLE LOAD FROM S3 Bucket

```sql
copy into INT_CPR_1
  from @HALLYM.share.hallym_stage/structured-csv-data/CPR-AI-predict/20220725v2_CPR_split_3.csv
  file_format = (format_name = hallym.share.NULLABLE_CSV_FORMAT);
```
![image](https://user-images.githubusercontent.com/52474199/214518532-765d0055-4be7-4436-8411-31533946cd4a.png)


## Step 3. 강릉아산, 울산대는 S3에 Data 저장 -> 한림대Ext Table 생성


### 1. 강릉아산 EXT table 생성
```sql
create or replace external table HALLYM.SHARE.EXT_CPR_3 (
    "작성시간" VARCHAR(20) AS (VALUE:c1:: VARCHAR),
    "__RRT" NUMBER(38,0) AS (VALUE:c2:: NUMBER),
    "__TOT_4" NUMBER(38,0) AS (VALUE:c3:: NUMBER),
    "__TOT_5" NUMBER(38,0) AS (VALUE:c4:: NUMBER),
    "__TOT_6" NUMBER(38,0) AS (VALUE:c5:: NUMBER),
    "__TOT_7" NUMBER(38,0) AS (VALUE:c6:: NUMBER),
    "호흡수" VARCHAR(5) AS (VALUE:c7:: VARCHAR),
    "__호흡점수" VARCHAR(5) AS (VALUE:c8:: VARCHAR),
    "산소포화도" VARCHAR(5) AS (VALUE:c9:: VARCHAR),
    "__산소포화도점수"	 NUMBER(38,0) AS (VALUE:c10:: NUMBER),
    "체온" VARCHAR(5) AS (VALUE:c11:: VARCHAR),
    "__체온점수" NUMBER(38,0) AS (VALUE:c12:: NUMBER),
    "혈압H" VARCHAR(5) AS (VALUE:c13:: VARCHAR),
    "__혈압점수" NUMBER(38,0) AS (VALUE:c14:: NUMBER),
    "맥박" VARCHAR(5) AS (VALUE:c15:: VARCHAR),
    "__맥박점수" NUMBER(38,0) AS (VALUE:c16:: NUMBER),
    "__의식변화" NUMBER(38,0) AS (VALUE:c17:: NUMBER),
    "__산소처방유무" NUMBER(38,0) AS (VALUE:c18:: NUMBER),
    "__RRT유무" NUMBER(38,0) AS (VALUE:c19:: NUMBER),
    "age60" NUMBER(38,0) AS (VALUE:c20:: NUMBER),
    "age70" NUMBER(38,0) AS (VALUE:c21:: NUMBER),
    "호흡점수v2" NUMBER(38,0) AS (VALUE:c22:: NUMBER),
    "산소포화도점수v2" NUMBER(38,0) AS (VALUE:c23:: NUMBER),
    "체온점수v2" NUMBER(38,0) AS (VALUE:c24:: NUMBER),
    "혈압점수v2" NUMBER(38,0) AS (VALUE:c25:: NUMBER),
    "맥박점수v2" NUMBER(38,0) AS (VALUE:c26:: NUMBER),
    "v2대상자" NUMBER(38,0) AS (VALUE:c27:: NUMBER),
    "최종대상자" NUMBER(38,0) AS (VALUE:c28:: NUMBER)
)
 
 with location =  @hallym.share.gnah_stage/structured-csv-data/CPR-AI-predict/
  file_format = hallym.share.NULLABLE_CSV_FORMAT;
```

### 2. 울산대 EXT table 생성

```sql
create or replace external table HALLYM.SHARE.EXT_CPR_2 (
    "작성시간" VARCHAR(20) AS (VALUE:c1:: VARCHAR),
    "__RRT" NUMBER(38,0) AS (VALUE:c2:: NUMBER),
    "__TOT_4" NUMBER(38,0) AS (VALUE:c3:: NUMBER),
    "__TOT_5" NUMBER(38,0) AS (VALUE:c4:: NUMBER),
    "__TOT_6" NUMBER(38,0) AS (VALUE:c5:: NUMBER),
    "__TOT_7" NUMBER(38,0) AS (VALUE:c6:: NUMBER),
    "호흡수" VARCHAR(5) AS (VALUE:c7:: VARCHAR),
    "__호흡점수" VARCHAR(5) AS (VALUE:c8:: VARCHAR),
    "산소포화도" VARCHAR(5) AS (VALUE:c9:: VARCHAR),
    "__산소포화도점수"	 NUMBER(38,0) AS (VALUE:c10:: NUMBER),
    "체온" VARCHAR(5) AS (VALUE:c11:: VARCHAR),
    "__체온점수" NUMBER(38,0) AS (VALUE:c12:: NUMBER),
    "혈압H" VARCHAR(5) AS (VALUE:c13:: VARCHAR),
    "__혈압점수" NUMBER(38,0) AS (VALUE:c14:: NUMBER),
    "맥박" VARCHAR(5) AS (VALUE:c15:: VARCHAR),
    "__맥박점수" NUMBER(38,0) AS (VALUE:c16:: NUMBER),
    "__의식변화" NUMBER(38,0) AS (VALUE:c17:: NUMBER),
    "__산소처방유무" NUMBER(38,0) AS (VALUE:c18:: NUMBER),
    "__RRT유무" NUMBER(38,0) AS (VALUE:c19:: NUMBER),
    "age60" NUMBER(38,0) AS (VALUE:c20:: NUMBER),
    "age70" NUMBER(38,0) AS (VALUE:c21:: NUMBER),
    "호흡점수v2" NUMBER(38,0) AS (VALUE:c22:: NUMBER),
    "산소포화도점수v2" NUMBER(38,0) AS (VALUE:c23:: NUMBER),
    "체온점수v2" NUMBER(38,0) AS (VALUE:c24:: NUMBER),
    "혈압점수v2" NUMBER(38,0) AS (VALUE:c25:: NUMBER),
    "맥박점수v2" NUMBER(38,0) AS (VALUE:c26:: NUMBER),
    "v2대상자" NUMBER(38,0) AS (VALUE:c27:: NUMBER),
    "최종대상자" NUMBER(38,0) AS (VALUE:c28:: NUMBER)
)
 
 with location =  @hallym.share.ulsan_stage/structured-csv-data/CPR-AI-predict/
  file_format = hallym.share.NULLABLE_CSV_FORMAT;
```

```sql
select count(*) from  HALLYM.SHARE.EXT_CPR_3;
```
![image](https://user-images.githubusercontent.com/52474199/214520113-3a4ed605-34af-48da-bad8-89bdb7723809.png)


## Step 4. 신규 Table 생성(내부 Table + Ext Table 2개 Union all)

### 1. 한림대 + 강릉아산 + 울산대 Data 
```sql
CREATE TABLE CPR AS
 SELECT * FROM INT_CPR_1
 
 UNION ALL
 
 SELECT "작성시간",
        "__RRT",
        "__TOT_4",
        "__TOT_5",
        "__TOT_6",
        "__TOT_7",
        "호흡수",
        "__호흡점수",
        "산소포화도",
        "__산소포화도점수",
        "체온",
        "__체온점수",
        "혈압H",
        "__혈압점수",
        "맥박",
        "__맥박점수",
        "__의식변화",
        "__산소처방유무",
        "__RRT유무",
        "age60",
        "age70",
        "호흡점수v2",
        "산소포화도점수v2",
        "체온점수v2",
        "혈압점수v2",
        "맥박점수v2",
        "v2대상자",
        "최종대상자" FROM EXT_CPR_2
        
 UNION ALL
         
 SELECT "작성시간",
        "__RRT",
        "__TOT_4",
        "__TOT_5",
        "__TOT_6",
        "__TOT_7",
        "호흡수",
        "__호흡점수",
        "산소포화도",
        "__산소포화도점수",
        "체온",
        "__체온점수",
        "혈압H",
        "__혈압점수",
        "맥박",
        "__맥박점수",
        "__의식변화",
        "__산소처방유무",
        "__RRT유무",
        "age60",
        "age70",
        "호흡점수v2",
        "산소포화도점수v2",
        "체온점수v2",
        "혈압점수v2",
        "맥박점수v2",
        "v2대상자",
        "최종대상자"
 FROM EXT_CPR_3;
```
```sql
select count(*) from CPR ;
```
![image](https://user-images.githubusercontent.com/52474199/214523404-0ff5486e-2265-4cbf-9dc7-db7eeaaac74c.png)


## Step 5. Data Sharing to 울산대, 강릉아산

### 1. Create a Share Object

```sql
USE ROLE ACCOUNTADMIN;
drop share EXT_SHARE_1;

// Create a Share Object
CREATE OR REPLACE SHARE EXT_SHARE_1;

// Grant usage on database
GRANT USAGE ON DATABASE HALLYM TO SHARE EXT_SHARE_1; 

// Grant usage on schema
GRANT USAGE ON SCHEMA HALLYM.SHARE TO SHARE EXT_SHARE_1; 

// Grant SELECT on table
GRANT SELECT ON TABLE "HALLYM"."SHARE"."CPR" TO SHARE EXT_SHARE_1; 
```

```sql
// Validate Grants
SHOW GRANTS TO SHARE EXT_SHARE_1;
```
![image](https://user-images.githubusercontent.com/52474199/214526263-4c4d363c-f53f-457a-b8dd-8ba9e7e01d76.png)

```sql
ALTER SHARE EXT_SHARE_1 ADD ACCOUNT=OM23657; /*강릉아산*/
ALTER SHARE EXT_SHARE_1 ADD ACCOUNT=UP52144; /*울산대*/
```
![image](https://user-images.githubusercontent.com/52474199/215707369-c0283d14-dc68-4c8c-abb7-61d4bc4f7e40.png)
![image](https://user-images.githubusercontent.com/52474199/215707733-d22700f1-3814-46df-a726-e41f6ba962d5.png)
![image](https://user-images.githubusercontent.com/52474199/215707797-b881d965-d2e0-4af9-839f-55485f088654.png)


### 2. on Consumer
```sql
drop database ext_share_1;

create database ext_share_1;
create schema ext_share_1;

use role accountadmin;
SHOW SHARES;

create or replace database ext_share_1 from share ATIXOAJ.HALLYM_POC.EXT_SHARE_1;
use ext_share_1;
use warehouse compute_wh;

select * from "EXT_SHARE_1"."SHARE"."CPR";
```

![image](https://user-images.githubusercontent.com/52474199/214991622-dd49139f-fb00-4d0a-a1f0-8eac2a6cf2b4.png)
