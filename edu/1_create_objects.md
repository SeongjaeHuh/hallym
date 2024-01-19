
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
