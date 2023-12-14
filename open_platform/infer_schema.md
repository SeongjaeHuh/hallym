## How to infer the schema of a csv file in Snowflake?

### 1. create csv file and stage
```csv
order_id,order_date,order_time,product_name,order_price,tax_value,existing_customer,customer_name,mobile_number
1,2023-06-04,13:19:14,Moto G Power,956.27,95.63,False,Robert Sherman,9152218975
2,2023-06-19,06:44:23,Nokia 8.3,658.97,65.9,True,Raymond Phillips,9872334088
3,2023-04-08,05:11:22,Moto G Power,1487.21,148.72,False,Thomas Thompson,9513069603
4,2023-06-06,03:33:53,iPhone 12,1310.52,131.05,True,Casey Mcdaniel,9620517344
5,2023-02-12,17:30:23,Galaxy Note 10,845.79,84.58,False,Jennifer Griffin,9045335526
6,2023-02-07,15:41:14,iPhone 12,1351.61,135.16,False,Dr. Michele Huang,9377330463
7,2023-06-15,12:10:09,iPhone SE,593.82,59.38,False,Timothy Guerrero,9785992101
8,2023-01-01,00:33:04,Galaxy Note 10,1334.09,133.41,False,Eric Hawkins,9324423643
9,2023-01-26,16:47:11,iPhone SE,1051.47,105.15,False,Sara Williams,9854478422
10,2023-05-21,00:11:13,Galaxy S21,687.52,68.75,False,Donna Velez,9876003384
```

create the stage
```sql
CREATE OR REPLACE STAGE HALLYM_S3_STAGE;
STORAGE_INTEGRATION = hallym_s3_int
URL = 's3://hallym-snowflake-stage'
FILE_FORMAT = CSV_FORMAT;
```
### 2. upload csv file to snowflake stage
```
HALLYM.HALLYM>put file://C:\Users\Heo\Downloads\order_data_10.csv @hallym_s3_stage;
```
![280458525-aa395212-c30e-4876-bc9c-e4fb487b6778](https://github.com/SeongjaeHuh/hallym/assets/52474199/89f2861d-4e4b-4739-b776-8326bc455965)

```sql
list @hallym_s3_stage
```
![280458592-3a38cbcd-8501-4f9d-b478-cfca612e5171](https://github.com/SeongjaeHuh/hallym/assets/52474199/e0346709-9798-4edc-b5fb-a4a8473011e1)



### 3. create file format
```sql
CREATE FILE FORMAT my_csv_format
  TYPE = csv
  PARSE_HEADER = true;

```
### 4. schema detection (infer schema)

```sql
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@MY_STAGE'
      , FILE_FORMAT=>'MY_CSV_FORMAT'
    )
);

```
![280446710-a0446630-0ffc-4c86-889b-75093725e457](https://github.com/SeongjaeHuh/hallym/assets/52474199/d5463bc9-d011-49ec-b7be-0a0d048f6e57)


### 5. crate table from infer schema
```sql
create table mytable
  using template (
    select array_agg(object_construct(*))
      from table(
        infer_schema(
      LOCATION=>'@MY_STAGE'
      , FILE_FORMAT=>'MY_CSV_FORMAT'
    )
));
```
### 6. desc Table

```sql
desc table mytable;
```
![280447933-874707a6-d97b-48a9-8150-69e85476c27d](https://github.com/SeongjaeHuh/hallym/assets/52474199/b88cddb8-80ce-413c-ab0d-443f201ee730)




```sql
select get_ddl('table', 'mytable');
```
```sql
create or replace TABLE MYTABLE ( "order_id" NUMBER(2,0), "order_date" DATE, "order_time" TIME(9), "product_name" VARCHAR(16777216), "order_price" NUMBER(6,2), "tax_value" NUMBER(5,2), "existing_customer" BOOLEAN, "customer_name" VARCHAR(16777216), "mobile_number" NUMBER(10,0) );
```

### 7. Load the CSV file using MATCH_BY_COLUMN_NAME

```sql
COPY into mytable from @MY_STAGE/ FILE_FORMAT = (FORMAT_NAME= 'my_csv_format') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;
```
![280447729-cd72f395-404b-4bf3-8fc3-9e1806dfc879](https://github.com/SeongjaeHuh/hallym/assets/52474199/a43b43a0-a43c-439e-8980-04f6bb14e267)




### 8. chcek the data

```sql
select * from mytable;
```
![280447511-7c8be86b-c28e-417f-82d6-62cbf44654cd](https://github.com/SeongjaeHuh/hallym/assets/52474199/8b790f32-88c2-4c4c-85c5-cd7aeaf89a9d)




