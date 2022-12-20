### CREATE NEW ROLE
```
CREATE ROLE NEW_ROLE_3;
```





-- grant role to the_user_we_want_to_assign
```
GRANT ROLE SALES_ADMIN TO USER ADMIN;
GRANT ROLE SALES_EU TO USER ADMIN;
GRANT ROLE SALES_US TO USER ADMIN;

```



-- object usage permission on SALES_ADMIN
```
grant usage on database access_control to role NEW_ROLE_3;
grant usage on all schemas in database access_control to role NEW_ROLE_3;

grant select,update,delete on table [db명][스키마명]SALES_RAW_1 to role NEW_ROLE_3;

```
