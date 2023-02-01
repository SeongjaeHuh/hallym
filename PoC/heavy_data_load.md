## Unload File from table to S3 using by Snowsql cli

### unload from table
```sql
copy into @new_stage/structured-csv-data/data-heavy-load/data_heavy-load
     from (select * from seq.seq.measurement_amp) 
     file_format = (format_name = 'MY_CSV_FORMAT');
```
![image](https://user-images.githubusercontent.com/52474199/216037236-ce8b061b-56de-43a6-842f-26008998feba.png)

![image](https://user-images.githubusercontent.com/52474199/216037382-b0a9f6b9-18c3-4fcc-a2af-8f4185e6ebbb.png)


### Create a table
```sql
create or replace TABLE MEASUREMENT_AMP_2 (
	ROW_ID VARCHAR(220) COMMENT '행_ID',
	MEASUREMENT_ID VARCHAR(200) NOT NULL DEFAULT '' COMMENT '검사생성ID',
	PERSON_ID VARCHAR(100) COMMENT '환자ID',
	MEASUREMENT_CONCEPT_ID VARCHAR(255) COMMENT '검사명표준ID',
	MEASUREMENT_DATE DATE COMMENT '검사날짜',
	MEASUREMENT_TIME TIME(9) COMMENT '검사시간',
	MEASUREMENT_TYPE_CONCEPT_ID NUMBER(38,0) COMMENT '검사자료유형표준ID',
	OPERATOR_CONCEPT_ID NUMBER(38,0) COMMENT '연산자표준ID',
	VALUE_AS_NUMBER NUMBER(20,10) COMMENT '숫자형검사결과값',
	VALUE_AS_CONCEPT_ID VARCHAR(255) COMMENT '검사결과표준ID',
	UNIT_CONCEPT_ID VARCHAR(30) COMMENT '검사단위표준ID',
	UNIT_CONCEPT_CODE VARCHAR(30) COMMENT '검사단위표준코드',
	RANGE_LOW VARCHAR(20) COMMENT '정상범위하한값',
	MODIFIER_LOW VARCHAR(20) COMMENT '정상범위하위문자형',
	RANGE_HIGH VARCHAR(20) COMMENT '정상범위상한값',
	MODIFIER_HIGH VARCHAR(20) COMMENT '정상범위상위문자형',
	ABN_IND VARCHAR(20) COMMENT '정상범위비교결과',
	PROVIDER_ID VARCHAR(255) COMMENT '의료기관명',
	VISIT_OCCURRENCE_ID VARCHAR(200) NOT NULL DEFAULT '' COMMENT '방문생성ID',
	MEASUREMENT_SOURCE_VALUE VARCHAR(255) COMMENT '원자료검사명',
	RESULT_TYPE VARCHAR(10) COMMENT '결과값유형 (숫자형 : N, 문자/범위형 : C)',
	MS_TEST_SUB_CATEGORY VARCHAR(20) COMMENT '검사분류',
	FAST_IND VARCHAR(10) COMMENT '검사전공복유무',
	SPECIMEN_SOURCE VARCHAR(10) COMMENT '검사시료종류',
	STAT VARCHAR(10) COMMENT '검사긴급성',
	PT_LOC VARCHAR(10) COMMENT '검사채취장소',
	RESULT_LOC VARCHAR(10) COMMENT '검사결과출력위치',
	PX_EDI_CODE VARCHAR(30) COMMENT '검사EDI코드',
	PX_CODETYPE VARCHAR(30) COMMENT '검사코드유형',
	MEASUREMENT_SOURCE_CONCEPT_ID VARCHAR(255) COMMENT '원자료검사명표준ID',
	UNIT_SOURCE_VALUE VARCHAR(30) COMMENT '원자료검사단위',
	VALUE_SOURCE_VALUE VARCHAR(4000) COMMENT '원자료검사결과값',
	LOINC VARCHAR(20) COMMENT 'LOINC코드',
	MODIFIER VARCHAR(5) COMMENT '검사결과연산자',
	ETL_DATETIME TIMESTAMP_NTZ(9) NOT NULL DEFAULT CURRENT_TIMESTAMP()
)COMMENT='검사정보'
;

```
```sql

COPY INTO "SEQ"."SEQ"."MEASUREMENT_AMP_2" 
     FROM '@new_stage/structured-csv-data/data-heavy-load/' 
     FILE_FORMAT = (format_name = 'MY_CSV_FORMAT') ON_ERROR = 'ABORT_STATEMENT' PURGE = FALSE;

```


![image](https://user-images.githubusercontent.com/52474199/216040103-5d1c5114-5ec8-4e3f-bcf7-6b132000c8f6.png)
![image](https://user-images.githubusercontent.com/52474199/216040237-3d00ff7c-7bc0-4226-ba3b-23a0aeb813a1.png)
