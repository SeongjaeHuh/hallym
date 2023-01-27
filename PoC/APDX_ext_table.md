# Create External Table

## 1. DB & 스키마 생성

```
create or replace database ext;
create or replace schema ext;
```

## 2. file format 생성
```
use hallym.hallym;

-- 생성
create or replace file format my_csv_format
type = csv
field_delimiter = ','
skip_header = 1
null_if = ('NULL','null')
empty_field_as_null = true;

```

-- unload 되는지 확인 (write 권한 확인)

```
copy into @mystage/;
--list @mystage/knee-mri-image/dataset/abnormal/010538603/
```
```
use hallym;
use schema hallym;
copy into @mystage/
from "HALLYM"."HALLYM"."HEART"
HEADER = true
overwrite = true;
```

## 3. EXT TABLE 생성
```
create or replace external table ext_customer_data
    (
      C_CUSTKEY    NUMBER(38,0)    AS (VALUE:c1::NUMBER), /*VALUE:C1 대문자 안됨*/
      C_NAME       VARCHAR(25)     AS (VALUE:c2::VARCHAR),
      C_ADDRESS    VARCHAR(40)     AS (VALUE:c3::VARCHAR),
      C_NATIONKEY  NUMBER(38,0)    AS (VALUE:c4::NUMBER),
      C_PHONE      VARCHAR(15)     AS (VALUE:c5::VARCHAR),
      C_ACCTBAL    NUMBER(12,2)    AS (VALUE:c6::NUMBER),
      C_MKTSEGMENT VARCHAR(10)     AS (VALUE:c7::VARCHAR),
      C_COMMENT    VARCHAR(117)    AS (VALUE:c8::VARCHAR)
    )
  with location =  @mystage/
  --auto_refresh = true
  file_format = my_csv_format;
```
```
use ext;
create schema EXT;
use hallym.hallym;
use schema hallym;
```



### (1). 수치형 응급실 중환자 심정지 AI 예측_EXT_Table 생성 

```
create or replace external table ext.ext.EXT_20220725v2_CPR (
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
  with location =  @hallym.hallym.new_stage/structured-csv-data/CPR-AI-predict/
  file_format = ext.ext.my_csv_format;
```


```
--20220725v2_CPR.csv
list @mystage/structured-csv-data/CPR-AI-predict/; 
```



### (2). 심장질환예측_EXT_Table 생성
```
create or replace external table ext.ext.EXT_HEART (
	ID NUMBER(38,0) AS (VALUE:c1::NUMBER),
	AGE NUMBER(38,0) AS (VALUE:c2::NUMBER),
	SEX NUMBER(38,0) AS (VALUE:c3::NUMBER),
	CP NUMBER(38,0) AS (VALUE:c4::NUMBER),
	TRESTBPS NUMBER(38,0) AS (VALUE:c5::NUMBER),
	CHOL NUMBER(38,0) AS (VALUE:c6::NUMBER),
	FBS NUMBER(38,0) AS (VALUE:c7::NUMBER),
	RESTECG NUMBER(38,0) AS (VALUE:c8::NUMBER),
	THALACH NUMBER(38,0) AS (VALUE:c9::NUMBER),
	EXANG NUMBER(38,0) AS (VALUE:c10::NUMBER),
	OLDPEAK FLOAT AS (VALUE:c11::FLOAT),
	SLOPE NUMBER(38,0) AS (VALUE:c12::NUMBER),
	CA NUMBER(38,0) AS (VALUE:c13::NUMBER),
	THAL NUMBER(38,0) AS (VALUE:c14::NUMBER),
	TARGET NUMBER(38,0) AS (VALUE:c15::NUMBER)
)
  with location =  @hallym.hallym.new_stage/structured-csv-data/heart-disease-predict/
  file_format = ext.ext.my_csv_format;
```


### (3). 후보 심부전증 사망 예측

```
create or replace external table ext.ext.EXT_HEART_FAILURE_CLINICAL_RECORDS (
	AGE	NUMBER(38,0) AS (VALUE:c1::NUMBER),
	ANAEMIA	NUMBER(38,0) AS (VALUE:c2::NUMBER),
	CREATININE_PHOSPHOKINASE NUMBER(38,0) AS (VALUE:c3::NUMBER),
	DIABETES NUMBER(38,0) AS (VALUE:c4::NUMBER),
	EJECTION_FRACTION NUMBER(38,0) AS (VALUE:c5::NUMBER),
	HIGH_BLOOD_PRESSURE	NUMBER(38,0) AS (VALUE:c6::NUMBER),
	PLATELETS NUMBER(38,0) AS (VALUE:c7::NUMBER),
	SERUM_CREATININE FLOAT AS (VALUE:c8::FLOAT),
	SERUM_SODIUM NUMBER(38,0) AS (VALUE:c9::NUMBER),
	SEX	NUMBER(38,0) AS (VALUE:c10::NUMBER),
	SMOKING	NUMBER(38,0) AS (VALUE:c11::NUMBER),
	TIME NUMBER(38,0) AS (VALUE:c12::NUMBER),
	DEATH_EVENT	NUMBER(38,0) AS (VALUE:c13::NUMBER)
)
  with location =  @hallym.hallym.new_stage/structured-csv-data/heart-failure-death-predict/
  file_format = ext.ext.my_csv_format;
```


### (참고) stage 파일 unload 및 삭제

#### 1. stage로 file unload
```
copy into @hallym.hallym.new_stage/structured-csv-data/heart-disease-predict/kokoko_  /*kokoko_ 를 접두사로 붙임*/
     from (select * from "HALLYM"."HALLYM"."HEALTH_CLINIC_DEPT")
     file_format=(format_name='my_csv_format' compression='gzip');
```
![image](https://user-images.githubusercontent.com/52474199/212236427-2d1e8d55-1c89-46ae-ae84-7765ca877398.png)

#### 2. 새로운 dir 생성도 가능
```
copy into @hallym.hallym.new_stage/structured-csv-data/data_dupl/kokoko_
     from (select * from "HALLYM"."HALLYM"."HEALTH_CLINIC_DEPT")
     file_format=(format_name='my_csv_format' compression='gzip');
```
![image](https://user-images.githubusercontent.com/52474199/212254610-bb26cb74-cacd-4273-b7c8-27ece4c7bbca.png)

#### 3. kokoko_ 패턴이 들어간 파일만 삭제 (rm 명령어는 ui에서도 가능)

```
rm @hallym.hallym.new_stage/structured-csv-data/heart-disease-predict pattern='.*kokoko.*'; 
```
![image](https://user-images.githubusercontent.com/52474199/212236984-7c71bf16-0626-455b-8f43-85df1eaf06c4.png)

remove files whose names match the pattern *jun* from the stage for the current user
```
rm @~ pattern='.*jun.*';
```
#### 4. 삭제 완료
```
list @hallym.hallym.new_stage/structured-csv-data/heart-disease-predict/;
```
![image](https://user-images.githubusercontent.com/52474199/212236887-7252408b-1184-4dd7-8021-cf65b9ed729f.png)



![image](https://user-images.githubusercontent.com/52474199/214237550-abdc3d48-1531-47a1-9b70-ca75624963ca.png)
