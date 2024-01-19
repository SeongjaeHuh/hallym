
1. database 생성
```sql
CREATE OR REPLACE DATABASE sf_tuts;
```
2. 정보 확인
```sql
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();
```

3. table 생성
```sql
CREATE OR REPLACE TABLE emp_basic (
   first_name STRING ,
   last_name STRING ,
   email STRING ,
   streetaddress STRING ,
   city STRING ,
   start_date DATE
   );
```

4. warehouse 생성
```sql
CREATE OR REPLACE WAREHOUSE sf_tuts_wh WITH
   WAREHOUSE_SIZE='X-SMALL'
   AUTO_SUSPEND = 180
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED=TRUE;
```
5. 현재정보 확인
```sql
SELECT CURRENT_WAREHOUSE();
```
6. put files in table stage
```sql
PUT file://C:\temp\employees0*.csv @sf_tuts.public.%emp_basic;
```
![image](https://github.com/SeongjaeHuh/hallym/assets/52474199/fc060f23-4c7b-4319-97a5-2307a5812b20)

7. Listing the staged files (Optional)
```
LIST @sf_tuts.public.%emp_basic;
```
![image](https://github.com/SeongjaeHuh/hallym/assets/52474199/b95239a3-8eb6-4f7e-90ea-2a8034ba95cd)

8. Copy data into target tables
   
```sql
COPY INTO emp_basic
  FROM @%emp_basic
  FILE_FORMAT = (type = csv field_optionally_enclosed_by='"')
  PATTERN = '.*employees0[1-5].csv.gz'
  ON_ERROR = 'skip_file';
```
![image](https://github.com/SeongjaeHuh/hallym/assets/52474199/d1fa5d32-8fbb-4788-b5d8-266a3f66ad3d)

9.Retrieve all data
```sql
SELECT * FROM emp_basic;
```

10. Insert additional data rows
```sql
INSERT INTO emp_basic VALUES
   ('Clementine','Adamou','cadamou@sf_tuts.com','10510 Sachs Road','Klenak','2017-9-22') ,
   ('Marlowe','De Anesy','madamouc@sf_tuts.co.uk','36768 Northfield Plaza','Fangshan','2017-1-26');
```

11. Query rows based on email address
```sql
SELECT email FROM emp_basic WHERE email LIKE '%.uk';
```
12. Query rows based on start date
* Filter the list by employees whose start date occurred earlier than January 1, 2017:
```sql
SELECT first_name, last_name, DATEADD('day',90,start_date) FROM emp_basic WHERE start_date <= '2017-01-01';
```
13. Summary
* Stage the data files to load. The files can be staged internally (in Snowflake) or in an external location. In this tutorial, you stage files internally.
* Copy data from the staged files into an existing target table. A running warehouse is required for this step.

14. (Optional) Tutorial cleanup
```sql
DROP DATABASE IF EXISTS sf_tuts;
DROP WAREHOUSE IF EXISTS sf_tuts_wh;
``` 
