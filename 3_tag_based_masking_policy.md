

### Step 1: Create a Custom Role and Assign Privileges

```sql
use role useradmin;
create role tag_admin;
use role accountadmin;
grant create tag on schema <schema_name> to role tag_admin;
grant apply tag on account to role tag_admin;
```

### Step 2: Grant the TAG_ADMIN Custom Role to a User

```sql
use role useradmin;
grant role tag_admin to user sfadmin;
```

### Step 3: Create a Tag

```sql
use role tag_admin;
use schema my_db.my_schema;
create tag cost_center;
```


### Step 4: Assign a Tag to a Snowflake Object
```sql
use role tag_admin;
create warehouse mywarehouse with tag (cost_center = 'sales');
```

```sql
use role tag_admin;
alter warehouse wh1 set tag cost_center = 'sales';
```


```sql
-- For a table or external table column

alter table <table_name> modify column <column_name> set tag <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ];
alter table <table_name> modify column <column_name> unset tag <tag_name> [ , <tag_name> , ... ];

-- For a view or materialized view column

alter view <view_name> modify column <column_name> set tag <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ];
alter view <view_name> modify column <column_name> unset tag <tag_name> [ , <tag_name> , ... ];
```

### Step 5: Track the Tags

1. Discover tags (Identify tags in your account:)
```sql
select * from snowflake.account_usage.tags
order by tag_name;
```
```sql
select system$get_tag('cost_center', 'my_table', 'table');
```
2. Identify assignments

```sql
select *
from table(snowflake.account_usage.tag_references_with_lineage('my_db.my_schema.cost_center'));
```

```sql
select * from snowflake.account_usage.tag_references
order by tag_name, domain, object_id;
```

```sql
select *
from table(my_db.information_schema.tag_references('my_table', 'table'));
```
