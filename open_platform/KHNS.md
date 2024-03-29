## How to infer the schema of a csv file in Snowflake?

### 1. upload csv file to snowflake stage

#### (1) create the external stage
```sql
CREATE OR REPLACE STAGE AWS_S3_STAGE
STORAGE_INTEGRATION = aws_s3_int
URL = 's3://hallym-snowflake-stage/'
```
#### (2) put data file (internal stage에서만 가능)
```
HALLYM.HALLYM>put file://C:\Users\Heo\Downloads\order_data_10.csv @hallym_s3_stage;
```

![280458525-aa395212-c30e-4876-bc9c-e4fb487b6778](https://github.com/SeongjaeHuh/hallym/assets/52474199/a576b8a2-263e-42a1-baa2-2de95db610fa)

#### (3) unload data file from khns table

```sql
copy into @AWS_S3_STAGE/KHNS/ from KHNS file_format=Hallym.public.tsv;
```
```
list @aws_s3_stage/KHNS/;
```
```
+----------------------------------------------------+---------+----------------------------------+-------------------------------+
| name                                               |    size | md5                              | last_modified                 |
|----------------------------------------------------+---------+----------------------------------+-------------------------------|
| s3://hallym-snowflake-stage/KHNS/data_0_0_0.csv.gz | 3430086 | 8d776dd98527e7d6a98f61dc598c4682 | Wed, 13 Dec 2023 06:57:47 GMT |
+----------------------------------------------------+---------+----------------------------------+-------------------------------+
```


### 2. create file format
```sql
CREATE OR REPLACE FILE FORMAT TSV
	FIELD_DELIMITER = '\t'
	TRIM_SPACE = TRUE
;
```
### 3. schema detection (infer schema)

```sql
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@aws_s3_stage/KHNS'
      , FILE_FORMAT=>'TSV'
    )
);

```
```
+-------------+---------------+----------+---------------------+------------------------+----------+
| COLUMN_NAME | TYPE          | NULLABLE | EXPRESSION          | FILENAMES              | ORDER_ID |
|-------------+---------------+----------+---------------------+------------------------+----------|
| c1          | TEXT          | True     | $1::TEXT            | KHNS/data_0_0_0.csv.gz |        0 |
| c2          | TEXT          | True     | $2::TEXT            | KHNS/data_0_0_0.csv.gz |        1 |
| c3          | TEXT          | True     | $3::TEXT            | KHNS/data_0_0_0.csv.gz |        2 |
| c4          | NUMBER(4, 0)  | True     | $4::NUMBER(4, 0)    | KHNS/data_0_0_0.csv.gz |        3 |
| c5          | NUMBER(2, 0)  | True     | $5::NUMBER(2, 0)    | KHNS/data_0_0_0.csv.gz |        4 |
| c6          | NUMBER(1, 0)  | True     | $6::NUMBER(1, 0)    | KHNS/data_0_0_0.csv.gz |        5 |
| c7          | NUMBER(1, 0)  | True     | $7::NUMBER(1, 0)    | KHNS/data_0_0_0.csv.gz |        6 |
| c8          | TEXT          | True     | $8::TEXT            | KHNS/data_0_0_0.csv.gz |        7 |
| c9          | NUMBER(1, 0)  | True     | $9::NUMBER(1, 0)    | KHNS/data_0_0_0.csv.gz |        8 |
| c10         | NUMBER(2, 0)  | True     | $10::NUMBER(2, 0)   | KHNS/data_0_0_0.csv.gz |        9 |
| c836        | NUMBER(1, 0)  | True     | $836::NUMBER(1, 0)  | KHNS/data_0_0_0.csv.gz |      835 |
| c837        | NUMBER(2, 0)  | True     | $837::NUMBER(2, 0)  | KHNS/data_0_0_0.csv.gz |      836 |
| c838        | NUMBER(1, 0)  | True     | $838::NUMBER(1, 0)  | KHNS/data_0_0_0.csv.gz |      837 |
+-------------+---------------+----------+---------------------+------------------------+----------+
838 Row(s) produced. Time Elapsed: 10.067s

```

### 5. crate table from infer schema

```sql
create table KHNS_INFERED
  using template (
    select array_agg(object_construct(*))
      from table(
        infer_schema(
      LOCATION=>'@AWS_S3_STAGE/KHNS/'
      , FILE_FORMAT=>'TSV'
    )
));
```

```
+------------------------------------------+                                    
| status                                   |
|------------------------------------------|
| Table KHNS_INFERED successfully created. |
+------------------------------------------+
1 Row(s) produced. Time Elapsed: 10.919s
```
### 6. desc Table

```sql
desc table mytable;
```
```
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| c1   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c2   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c3   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c4   | NUMBER(4,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c5   | NUMBER(2,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c6   | NUMBER(1,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c836 | NUMBER(1,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c837 | NUMBER(2,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| c838 | NUMBER(1,0)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
838 Row(s) produced. Time Elapsed: 0.284s

```

```sql
select get_ddl('table', 'mytable');
```
```
+----------------------------------------+                                      
| GET_DDL('TABLE', 'KHNS_INFERED')       |
|----------------------------------------|
| create or replace TABLE KHNS_INFERED ( |
| 	"c1" VARCHAR(16777216),          |
| 	"c2" VARCHAR(16777216),          |
| 	"c3" VARCHAR(16777216),          |
| 	"c4" NUMBER(4,0),                |
| 	"c5" NUMBER(2,0),                |
| 	"c6" NUMBER(1,0),                |
| 	"c837" NUMBER(2,0),              |
| 	"c838" NUMBER(1,0)               |
| );                                     |
+----------------------------------------+
1 Row(s) produced. Time Elapsed: 0.536s
```

### 7. Load the CSV file using MATCH_BY_COLUMN_NAME

```sql
COPY into KHNS_INFERED from @AWS_S3_STAGE/KHNS/ FILE_FORMAT = (FORMAT_NAME= 'TSV');
```
```
+----------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                               | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|----------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://hallym-snowflake-stage/KHNS/data_0_0_0.csv.gz | LOADED |        7090 |        7090 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+----------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 3.782s
```

### 8. chcek the data

```sql
select * from KHNS_INFERED;
```
![스크린샷 2023-12-14 오후 12 56 35](https://github.com/SeongjaeHuh/hallym/assets/52474199/213a1783-8c07-4345-b9c5-e5d6c81cd3e2)


