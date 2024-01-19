```sql
CREATE OR REPLACE DATABASE sf_tuts;
```

```sql
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();
```
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

```sql
CREATE OR REPLACE WAREHOUSE sf_tuts_wh WITH
   WAREHOUSE_SIZE='X-SMALL'
   AUTO_SUSPEND = 180
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED=TRUE;
```

```sql
SELECT CURRENT_WAREHOUSE();
```
