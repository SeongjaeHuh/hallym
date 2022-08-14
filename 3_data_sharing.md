# Data Sharing
## Provider side

```
---- Data Provider (jn90843) ----
/* Create shares with a role that has CREATE SHARES privileges */
USE ROLE ACCOUNTADMIN; 
```
```
---- Sample Data 생성 ----
CREATE OR REPLACE DATABASE DATA_S;
USE DATA_S;
CREATE OR REPLACE TABLE DATA_S.PUBLIC.CUSTOMERS (
  id int,
  first_name string,
  last_name string,
  email string,
  gender string,
  Job string);
```
```
TRUNCATE TABLE CUSTOMERS;
INSERT INTO CUSTOMERS
VALUES
(1,'Bourke','Treble','btreble0@g.co','M','Health Coach'),
(2,'Iormina','Lahy','ilahy1@sciencedaily.com','M','Web Designer'),
(3,'Tracy','Curwen','tcurwen2@spiegel.de','M','Analyst Programmer'),
(4,'Megan','Omond','momond3@cyberchimps.com','F','Data Engineer'),
(5,'Bryana','Coton','bcoton4@google.nl','F','Web Designer'),
(6,'Christoffer','Woolward','cwoolward5@imgur.com','F','Health Coach'),
(7,'Olympia','Pappin','opappin6@unesco.org','F','Analyst Programmer'),
(8,'Grant','Sandal','gsandal7@cpanel.net','M','Analyst Programmer'),
(9,'Elias','Bertomier','ebertomier8@tmall.com','M','Data Engineer'),
(10,'Rex','Kinzel','rkinzel9@yellowpages.com','M','Design Engineer')
;
```
![image](https://user-images.githubusercontent.com/52474199/183401893-04c9ca50-452c-4667-acd1-ddec9ef79498.png)


```
SELECT * FROM CUSTOMERS;
```

```
---- Create a share object ----
CREATE OR REPLACE SHARE CUSTOMERS_SHARE;
```

```
---- Setup Grants ----
// Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE CUSTOMERS_SHARE; 
// Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE CUSTOMERS_SHARE; 
// Grant SELECT on table
GRANT SELECT ON TABLE DATA_S.PUBLIC.CUSTOMERS TO SHARE CUSTOMERS_SHARE; 
// Validate Grants
SHOW GRANTS TO SHARE CUSTOMERS_SHARE;
```

```
---- Add Consumer Account ----
ALTER SHARE CUSTOMERS_SHARE ADD ACCOUNT=skcctest01;
```
![image](https://user-images.githubusercontent.com/52474199/183403120-503450ff-d8df-42fe-b052-1ea5e37a339e.png)


## Consumer Side

```
--------------------------------------Data Customer------------------------
use role ACCOUNTADMIN;
show shares;
```
![image](https://user-images.githubusercontent.com/52474199/183402575-3984270c-5a75-4240-8561-e9ac490c0ab1.png)


```
desc share jn90843.CUSTOMERS_SHARE; /* from provider account (shared from) */
```
![image](https://user-images.githubusercontent.com/52474199/183402869-5d5dcb5f-4a57-4f97-ae4d-77cabc187c7c.png)

```
create or replace database DATA_S from share jn90843.CUSTOMERS_SHARE;
use DATA_S;
select * from DATA_S.PUBLIC.CUSTOMERS;
```
![image](https://user-images.githubusercontent.com/52474199/183402945-5d2e71aa-1f38-479c-b847-d51ff28e4237.png)



# Case 2
## Reader account

```
-- Create Reader Account --
DROP MANAGED ACCOUNT demo_account;
CREATE MANAGED ACCOUNT demo_account
ADMIN_NAME = demo_admin,
ADMIN_PASSWORD = 'Qwer!234',
TYPE = READER;

--{"accountName":"DEMO_ACCOUNT","accountLocator":"VY93929","url":"https://avlmfgz-demo_account.snowflakecomputing.com","accountLocatorUrl":"https://vy93929.ap-northeast-2.aws.snowflakecomputing.com"}

```
```
// Make sure to have selected the role of accountadmin
USE ROLE ACCOUNTADMIN; 
// Show accounts
SHOW MANAGED ACCOUNTS;
```
![image](https://user-images.githubusercontent.com/52474199/184528012-fe0f75d8-4dc8-465a-b0f1-d8de50de2b7c.png)

```
-- Share the data -- 
ALTER SHARE CUSTOMERS_1_SHARE ADD ACCOUNT = VY93929; /*바로 위에 Managed Acccount 생성할 때 나온 account Locator*/
```
```
select * from DATA_S.PUBLIC.CUSTOMERS_1;
```
![image](https://user-images.githubusercontent.com/52474199/183608166-4bc418de-c179-43f7-81dd-0e7db7146f7d.png)


```
delete from DATA_S.PUBLIC.CUSTOMERS_1 where ID = 1;
select * from DATA_S.PUBLIC.CUSTOMERS_1;
```
![image](https://user-images.githubusercontent.com/52474199/183608285-b9863465-144d-4903-9755-5a4f807ef8a6.png)

```
--truncate table DATA_S.PUBLIC.CUSTOMERS_1;
--drop table DATA_S.PUBLIC.CUSTOMERS_1;
```

## Reader Account
### 리더 주소로 접속

```

accountLocatorUrl: "https://vy93929.ap-northeast-2.aws.snowflakecomputing.com"
ADMIN_NAME = demo_admin,
ADMIN_PASSWORD = 'Qwer!234',

```



```
--------------Login Reader Account---------------------------------------
-- Create database from share --
// Make sure to have selected the role of accountadmin
USE ROLE ACCOUNTADMIN; 
// Show all shares (consumer & producers)
SHOW SHARES;
```
![image](https://user-images.githubusercontent.com/52474199/183606222-be8abb60-e56f-4289-a0c0-53491769e5cb.png)


```
// See details on share
DESC SHARE jn90843.CUSTOMERS_1_SHARE; /*shared from account가 jn90843임 */
```

![image](https://user-images.githubusercontent.com/52474199/184528305-0e7852ec-5752-4a61-b519-859d15acae17.png)


```
// Create a database in consumer account using the share
CREATE OR REPLACE DATABASE DATA_SHARE_DB FROM SHARE jn90843.CUSTOMERS_1_SHARE;--<account_name_producer>.CUSTOMERS_SHARE;

```
![image](https://user-images.githubusercontent.com/52474199/183607363-24237e0d-9717-4e8d-ba6c-fc3a92f5a820.png)


```
// Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;
```

![image](https://user-images.githubusercontent.com/52474199/183607742-4b50a60e-d22f-43e0-aa4c-8c2326012155.png)


```
// Validate table access
SELECT * FROM DATA_SHARE_DB.PUBLIC.CUSTOMERS;
```

![image](https://user-images.githubusercontent.com/52474199/183607839-8f8a1a81-20f4-4de6-8f3f-b8e9d3ef56ef.png)


> 참고로 shared db를 1건 delete 하니 공유 받은 쪽에서도 delete가 되네. sync가 되는구나.
> 원천에서 drop 해도 reader에서 드랍되고, 원천에서 다시 크리에이트 한 뒤, 데이터 생성해주고, GRANT 주니까 reader에서 잘 보임

![image](https://user-images.githubusercontent.com/52474199/183609959-711228f0-3fba-43c1-ae84-835e1ec2fb36.png)


![image](https://user-images.githubusercontent.com/52474199/183608619-eace4bfa-365c-4251-8ad9-97a38bb13ffd.png)

