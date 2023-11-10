## How to Sync. Data Set from HERO to Snowflake?

### Process
![ellon drawio](https://github.com/SeongjaeHuh/hallym/assets/52474199/c7bf2269-3e3f-4efd-a7d5-3c60592d118c)
```
Snowflake와 MIG.App은 JDBC connection
Migration 요청
S3로 Unload
(Mig App) Table 생성(Infer Schema), File_Format 생성
Snowflake로 적재
```
