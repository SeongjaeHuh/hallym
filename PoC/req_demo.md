## 추가 검증용

### 1. 테이블 3개 생성
```sql
create or replace TABLE "INT_CPR_3" (
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

2. Stage, Fileformat 생성 후 적재
```sql

CREATE STAGE hallym_stage URL = 's3://hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = '==' AWS_SECRET_KEY = '==');
CREATE STAGE gnah_stage URL = 's3://asan-hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = '==' AWS_SECRET_KEY = '==');
CREATE STAGE ulsan_stage URL = 's3://ulsan-hallym-uni-poc-bucket' CREDENTIALS = (AWS_KEY_ID = '==' AWS_SECRET_KEY = '==');

```

```sql
CREATE FILE FORMAT NULLABLE_CSV_FORMAT 
   COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' 
   SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' TRIM_SPACE = FALSE
   ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134' 
   DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('NULL');
   
```
3. Load
```sql
copy into INT_CPR_1
  from @DEMO2.DEMO2.hallym_stage/structured-csv-data/CPR-AI-predict/20220725v2_CPR_split_3.csv
  file_format = (format_name = DEMO.DEMO.NULLABLE_CSV_FORMAT);

copy into INT_CPR_2
  from @DEMO1.DEMO1.gnah_stage/structured-csv-data/CPR-AI-predict/20220725v2_CPR_split_1.csv
  file_format = (format_name = DEMO.DEMO.NULLABLE_CSV_FORMAT);
  
copy into INT_CPR_3
  from @DEMO1.DEMO1.ulsan_stage/structured-csv-data/CPR-AI-predict/20220725v2_CPR_split_2.csv
  file_format = (format_name = DEMO.DEMO.NULLABLE_CSV_FORMAT);
  
```

3. amplify * 128배
```sql
--한림대 : 11577472
--울산대 강릉아산 : 8960000
insert into INT_CPR_3 select * from INT_CPR_3;
```
5. Unload data to S3

```
copy into @hallym.hallym.new_stage/structured-csv-data/ulsan-data-heavy-load/data_heavy-load
     from (select * from INT_CPR_3) 
     file_format = (format_name = 'NULLABLE_CSV_FORMAT');

copy into @hallym.hallym.new_stage/structured-csv-data/gnah-data-heavy-load/data_heavy-load
     from (select * from INT_CPR_2) 
     file_format = (format_name = 'NULLABLE_CSV_FORMAT');
     
copy into @hallym.hallym.new_stage/structured-csv-data/hallym-data-heavy-load/data_heavy-load
     from (select * from INT_CPR_1) 
     file_format = (format_name = 'NULLABLE_CSV_FORMAT');
```
6. make a ext table

```sql

     
  create or replace external table DEMO2.DEMO2.EXT_CPR_3 (
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
 
 with location =  @hallym.hallym.new_stage/structured-csv-data/ulsan-data-heavy-load/
  file_format = NULLABLE_CSV_FORMAT;
  
     
  create or replace external table DEMO2.DEMO2.EXT_CPR_2 (
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
 
 with location =  @hallym.hallym.new_stage/structured-csv-data/gnah-data-heavy-load/
  file_format = NULLABLE_CSV_FORMAT;
  
     
  create or replace external table DEMO2.DEMO2.EXT_CPR_1 (
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
 
 with location =  @hallym.hallym.new_stage/structured-csv-data/hallym-data-heavy-load/
  file_format = NULLABLE_CSV_FORMAT;

```
9. 건수 확인

```sql
select count(*) from EXT_CPR_1;
select count(*) from EXT_CPR_2;
select count(*) from EXT_CPR_3;
```
11. 결과 확인 (INT vs EXT)
```sql
select * from "DEMO2"."DEMO2"."INT_CPR_1"
union all 
select * from "DEMO2"."DEMO2"."INT_CPR_2"
union all 
select * from "DEMO2"."DEMO2"."INT_CPR_3";
```
![image](https://user-images.githubusercontent.com/52474199/216297814-5a41943d-f473-45ad-805f-7327a894dd71.png)


```sql
select * from "DEMO2"."DEMO2"."EXT_CPR_1"
union all 
select * from "DEMO2"."DEMO2"."EXT_CPR_2"
union all 
select * from "DEMO2"."DEMO2"."EXT_CPR_3";
```
![image](https://user-images.githubusercontent.com/52474199/216297610-77eccfcc-afd0-4f1d-a42d-0c9947254d16.png)

12. conclusion
> internal table 이 Exteranl table 대비 약 9.8배 속도가 빠름


14. 
