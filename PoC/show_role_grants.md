## 1. How to show grants to role?
```
select * from "SNOWFLAKE"."ACCOUNT_USAGE"."GRANTS_TO_ROLES" limit 10;
```
![image](https://user-images.githubusercontent.com/52474199/216776788-f1e50534-8b00-4e2c-b977-589bdf7f3591.png)


## 2. How to show grants to user?
```
select * from snowflake.account_usage.grants_to_users limit 10;
```
![image](https://user-images.githubusercontent.com/52474199/216776881-7dbe1901-bb83-4a97-ba46-839a56dcd5d1.png)

## 3. How to show which user have a privilege in the object?

```
select * from "SNOWFLAKE"."ACCOUNT_USAGE"."GRANTS_TO_ROLES" where grantee_name IN (
select ROLE from snowflake.account_usage.grants_to_users where GRANTEE_NAME = 'USER_IN_HALF') and GRANTED_ON = 'TABLE';
```
![image](https://user-images.githubusercontent.com/52474199/216777538-cd869fc2-fe38-4fc3-a60f-62c6397c7ac3.png)

![image](https://user-images.githubusercontent.com/52474199/216777471-e160a772-7188-4be5-bb69-abc8b2887bb5.png)



