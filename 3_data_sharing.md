# Data Sharing

## Data Sharing Type
###  Providers
1. Snowflake account that creates shares and makes them available for others to consume.
2. Unlimited number of shares can be created, and an unlimited number of accounts can be added to a share
3. Grants provide granular access control to selected objects, including at the row level (using filters)

### Consumers
1. Snowflake account that accesses a share from another account.
2. Create a local database to "hold" the share
3. Can consume an unlimited number of shares.
4. Are charged for their own compute on that share.


![image](https://user-images.githubusercontent.com/52474199/184577761-8ecc9f99-8d58-46cc-af94-ae0118766ff4.png)


## About Shares
1. Shares are read-only
2. Tables, secure views, and secure UDFs can be shared
3. Access to a share can be revoked at any time
4. Consumers can create new tables from a share
5. Shares are limited to a single region and cloud provider. Database replication can be used to share to another region or cloud provider.


## on Provider side

### Data Provider (jn90843)
```
/* Create shares with a role that has CREATE SHARES privileges */
USE ROLE ACCOUNTADMIN; 
```

### Step 1: Create Sample Data

```
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

### Step 2: Create a share object

```
CREATE OR REPLACE SHARE CUSTOMERS_SHARE;
```

### Step 3: Setup Grants

```
// Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE CUSTOMERS_SHARE; 
// Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE CUSTOMERS_SHARE; 
// Grant SELECT on table
GRANT SELECT ON TABLE DATA_S.PUBLIC.CUSTOMERS TO SHARE CUSTOMERS_SHARE; 
// Validate Grants
SHOW GRANTS TO SHARE CUSTOMERS_SHARE;
```
![image](https://user-images.githubusercontent.com/52474199/184577142-8591196f-bf57-417b-b0f3-e7d4895bacb9.png)

### Step 4: Create Reader Account
```
DROP MANAGED ACCOUNT demo_account;
CREATE MANAGED ACCOUNT demo_account
ADMIN_NAME = demo_admin,
ADMIN_PASSWORD = 'Qwer!234',
TYPE = READER;

--{"accountName":"DEMO_ACCOUNT","accountLocator":"VY93929","url":"https://avlmfgz-demo_account.snowflakecomputing.com","accountLocatorUrl":"https://vy93929.ap-northeast-2.aws.snowflakecomputing.com"}

```
### Step 5: MANAGED ACCOUNTS check
```
// Make sure to have selected the role of accountadmin
USE ROLE ACCOUNTADMIN; 
// Show accounts
SHOW MANAGED ACCOUNTS;
```
![image](https://user-images.githubusercontent.com/52474199/184528012-fe0f75d8-4dc8-465a-b0f1-d8de50de2b7c.png)


### Step 6: Share the data
```
ALTER SHARE CUSTOMERS_1_SHARE ADD ACCOUNT = VY93929; /*바로 위에 Managed Acccount 생성할 때 나온 account Locator*/
```
```
select * from DATA_S.PUBLIC.CUSTOMERS_1;
```
![image](https://user-images.githubusercontent.com/52474199/183608166-4bc418de-c179-43f7-81dd-0e7db7146f7d.png)


## on Reader Account
### Login to Reader Account

```
accountLocatorUrl: "https://vy93929.ap-northeast-2.aws.snowflakecomputing.com"
ADMIN_NAME = demo_admin,
ADMIN_PASSWORD = 'Qwer!234',

```


### Step 7: Create database from share
```
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

### Step 8: Create a database in consumer account using the share

```
CREATE OR REPLACE DATABASE DATA_SHARE_DB FROM SHARE jn90843.CUSTOMERS_1_SHARE;--<account_name_producer>.CUSTOMERS_SHARE;

```
![image](https://user-images.githubusercontent.com/52474199/183607363-24237e0d-9717-4e8d-ba6c-fc3a92f5a820.png)


### Step 9: Setup virtual warehouse
```
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;
```

![image](https://user-images.githubusercontent.com/52474199/183607742-4b50a60e-d22f-43e0-aa4c-8c2326012155.png)


```
// Validate table access
SELECT * FROM DATA_SHARE_DB.PUBLIC.CUSTOMERS_1;
```

![image](https://user-images.githubusercontent.com/52474199/183607839-8f8a1a81-20f4-4de6-8f3f-b8e9d3ef56ef.png)
