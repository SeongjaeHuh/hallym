# EXTERNAL TABLES

![image](https://user-images.githubusercontent.com/52474199/197577548-d791831b-56e6-40c5-b40c-f8649e57c917.png)

![image](https://user-images.githubusercontent.com/52474199/197571971-2ec17f4d-a370-4de7-8537-220c682d9f7e.png)
![image](https://user-images.githubusercontent.com/52474199/197572044-681288bb-7ea0-46ce-81bc-b120e8723990.png)
![image](https://user-images.githubusercontent.com/52474199/197568900-acd7fd9a-3709-4909-9014-dc2c8305b37f.png)
![image](https://user-images.githubusercontent.com/52474199/197572276-0c667a1e-08ea-4b87-8936-4cb965ef7567.png)
![image](https://user-images.githubusercontent.com/52474199/197572323-6a90040c-3418-4847-9eb5-fd75d7e19d1a.png)



### Create stage where external table files reside
```
CREATE STAGE my_external_stage
 URL='<path>'
 ...;
```

### Create external table, optionally with partitioning
```
CREATE EXTERNAL TABLE my_external_table
LOCATION = @my_external_stage
PARTITIONED BY(
 order_date STRING AS split_part (METADATA$FILENAME, '/', 5), 
 storeID STRING AS split_part (METADATA$FILENAME, '/', 6)
FILE_FORMAT = (FORMAT_NAME = parquet)
ON_ERROR = SKIP_FILE

```

![image](https://user-images.githubusercontent.com/52474199/197571158-60c2b76f-befd-4b9f-8e8e-75e04a0f0981.png)


## QUERY EXTERNAL TABLE
```
SELECT 
cust_id, prod_id, store_id, order_date, total_amt
FROM my_external_table
WHERE 
 storeId_part = 234 AND
order_date_part > '2020-06-30' AND 
order_date_part < '2020-12-31'
;
```
![image](https://user-images.githubusercontent.com/52474199/197570598-1fd4c311-2272-423c-9bd9-e5316471cb62.png)

# Security
1. All security features available for regular tables (RBAC, privileges) are also available for external tables
2. All encryption options supported by external stage are supported by external tables
3. There is separate privilege to create external tables
```
GRANT CREATE EXTERNAL TABLE
ON EXTERNAL_SCHEMA 
TO ROLE project_admin;
```

![image](https://user-images.githubusercontent.com/52474199/197573348-49b975cf-b53a-4227-a1ac-56e133c8b30f.png)


![image](https://user-images.githubusercontent.com/52474199/197573473-a94f5bd0-338e-4634-bf87-974147febee8.png)

![image](https://user-images.githubusercontent.com/52474199/197573710-bdf6dfbc-e203-4d5c-b89c-c56dcf1d1532.png)
![image](https://user-images.githubusercontent.com/52474199/197573949-4c0512f6-5315-44ab-b16b-1940065bf645.png)
![image](https://user-images.githubusercontent.com/52474199/197575005-bf75a771-61f2-4eec-a5ad-ccece2b6fd53.png)
![image](https://user-images.githubusercontent.com/52474199/197575130-c8d31317-dc9d-451f-b92e-2054b8428e9b.png)


![image](https://user-images.githubusercontent.com/52474199/197575335-a1648d96-1be9-4d24-b358-0188f19cb8e9.png)

![image](https://user-images.githubusercontent.com/52474199/197575487-726eef45-e114-44a1-bec2-484f80acbaa8.png)
![image](https://user-images.githubusercontent.com/52474199/197575640-a335492e-e849-41a1-9829-e3e925bab9ac.png)




### DB 생성
```
create or replace database ext_tables;
```
### File format 생성

```
create or replace file format my_csv_format
  type = csv
  field_delimiter = ','
  skip_header = 1
  null_if = ('NULL','null') --replaces values with SQL NULL
  empty_field_as_null =  true;  --replaces empty fields with SQL NULL
```

### Stage 생성 (my_s3_stage, UN, 9X)

```
create or replace stage my_s3_stage url = 's3://poc-bucket-hallym/sample/'
  credentials = (aws_key_id ='AKIATHYYQ43ZMLL3GL==', aws_secret_key = 'gebql8lB9NXQzI1SsFV5byR2l7vsyFd51ydoQT==') --need your own keys here
  file_format = my_csv_format;
```

### Unload Data to S3 External Stage

```  
copy into @my_s3_stage/Customer
from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
HEADER = true
overwrite = true;
```

### List Stage files

```
list @my_s3_stage;
```

![image](https://user-images.githubusercontent.com/52474199/201831432-b71e4ca0-1167-40ac-ad93-f3adad9c697c.png)

### Create external table

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
  with location =  @my_s3_stage/
  --auto_refresh = true
  file_format = my_csv_format;
```
![image](https://user-images.githubusercontent.com/52474199/201832872-0bd652fe-b9b2-47d8-819d-8329cc4f3d8c.png)

```
select * from ext_customer_data;
```
![image](https://user-images.githubusercontent.com/52474199/201834021-dea9f3dd-9cef-4e36-856e-d0d6b31365fd.png)


https://www.youtube.com/watch?v=o32GpHbn5w8


