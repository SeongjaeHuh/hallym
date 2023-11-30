
[접근통제 개요 및 Best Practices](https://community.snowflake.com/s/article/Snowflake-Security-Overview-and-Best-Practices)

[접근통제 계층 모델 권한상속](https://docs.snowflake.com/ko/user-guide/security-access-control-overview#label-role-hierarchy-and-privilege-inheritance)

[커스텀롤 고려사항](https://docs.snowflake.com/en/user-guide/security-access-control-considerations#managing-custom-roles)


### 1. 엑세스 제어 프레임워크

#### (1) Snowflake는 다음 두 모델을 결합하는 방식으로 액세스 제어를 수행합니다.
1. 사용자 지정 액세스 제어(DAC): 각 오브젝트에는 소유자가 있으며 소유자는 해당 오브젝트에 대한 액세스 권한을 부여할 수 있습니다.
2. 역할 기반 액세스 제어(RBAC): 액세스 권한은 역할에 할당되며, 이후에 사용자에게 할당됩니다.
3. (참고) Snowflake에는 인증 확인을 우회할 수 있는 《수퍼 사용자》 또는 《수퍼 역할》이라는 개념이 없습니다. 모든 액세스에는 적절한 액세스 권한이 필요합니다.

#### (2) 주요 개념

1. 보안 오브젝트: 액세스 권한이 부여될 수 있는 엔터티입니다. 권한 부여에 의해 허용되는 경우를 제외하고, 액세스가 거부됩니다.

2. 역할: 권한이 부여될 수 있는 엔터티입니다. 이후에 사용자에게 역할이 할당됩니다. 역할을 다른 역할에 할당하여 역할 계층 구조를 생성하는 것도 가능하다는 점에 유의하십시오.

3. 권한: 오브젝트에 대한 정의된 액세스 수준입니다. 여러 고유 권한을 사용하여 부여된 액세스를 세밀하게 제어할 수 있습니다.

4. 사용자: 사람 또는 프로그램과의 연결 여부와 관계없이, Snowflake에서 인식하는 사용자 ID입니다.
![334](https://github.com/SeongjaeHuh/snowflake/assets/52474199/fd4cc1e0-e371-4361-9ec5-dd87d124d016)


* Snowflake 모델에서는 역할에 할당된 권한을 통해 보안 오브젝트에 액세스할 수 있습니다. 그런 다음, 이러한 권한은 사용자나 다른 역할에 할당됩니다. 역할을 다른 역할에 부여하면 이 항목의 역할 계층 구조 및 권한 상속 섹션에 설명되어 있는 역할 계층이 생성됩니다.

 ![스크린샷 2023-11-28 오후 5 29 42](https://github.com/SeongjaeHuh/snowflake/assets/52474199/397f2cbe-d453-4d40-b2e1-f2d459a2ff6c)


### 2. 보안 오브젝트 

#### (1) 오브젝트 계층 구조
 
![스크린샷 2023-11-28 오후 5 30 56](https://github.com/SeongjaeHuh/snowflake/assets/52474199/b20ad59a-1ab0-4dd6-a5d2-d73343a0a415) 

#### (2) 역할 계층 구조 및 권한 상속

 1) ACCOUNTADMIN (즉, 계정 관리자)
 * SYSADMIN 및 SECURITYADMIN 시스템 정의 역할을 캡슐화하는 역할입니다. 시스템의 최상위 역할이며 계정에서 제한/통제된 수의 사용자에게만 부여되어야 합니다.

2) SECURITYADMIN (즉, 보안 관리자)
 * 모든 오브젝트 권한 부여를 전역적으로 관리하고 사용자 및 역할을 생성, 모니터링 및 관리할 수 있는 역할입니다. 보다 구체적으로 살펴보면, 이 역할은 취소 등 모든 권한 부여를 수정할 수 있는 MANAGE GRANTS 보안 권한이 부여됩니다.

3) SYSADMIN (즉, 시스템 관리자)
 * 계정에서 웨어하우스 및 데이터베이스(및 기타 오브젝트)의 생성 권한이 있는 역할입니다.
 * 권장 사항 에서와 같이, 모든 사용자 지정 역할을 SYSADMIN 역할에 할당하는 역할 계층 구조를 생성하는 경우 이 역할은 웨어하우스, 데이터베이스 및 기타 오브젝트에 대한 권한을 다른 역할에 부여할 수도 있습니다.

4) USERADMIN (즉, 사용자 및 역할 관리자)
 * 사용자 및 역할 관리만을 수행하는 역할입니다. 보다 구체적으로 살펴보면, 이 역할은:
 * CREATE USER 및 CREATE ROLE 보안 권한이 부여됩니다.
 * 계정에서 사용자 및 역할을 생성할 수 있습니다.

 5) PUBLIC
 * 모든 사용자와 계정의 모든 역할에 자동으로 부여되는 역할입니다.

![스크린샷 2023-11-28 오후 5 36 42](https://github.com/SeongjaeHuh/snowflake/assets/52474199/e79e07a0-42d0-4b32-8526-dae3de3b005c)

### (3) 권한 상속의 예
* 역할 3의 권한이 역할 2에 부여되었습니다.
* 역할 2의 권한이 역할 1에 부여되었습니다.
* 역할 1의 권한이 사용자 1에 부여되었습니다.

![스크린샷 2023-11-28 오후 5 39 35](https://github.com/SeongjaeHuh/snowflake/assets/52474199/d6d0fb31-84fa-46eb-98ff-3367188fc8fb)

* 역할 2는 권한 C를 상속합니다.
* 역할 1은 권한 B 및 C를 상속합니다.
* 사용자 1에는 모두 3개의 권한이 있습니다.

### 3. 오브젝트 레벨 접근 통제

#### (1) Best Practice
두가지 유형의 논리적 역할 정의
* Functional Role
* Access Role

DB단위로 3가지 엑세스 역할로 정함
* DB1_RO(읽기 전용 액세스용)
* DB1_RW(읽기-쓰기 액세스용)
* DB1_ADMIN(관리 작업용)
  
![스크린샷 2023-11-28 오후 5 44 02](https://github.com/SeongjaeHuh/snowflake/assets/52474199/1441920a-83c0-47ce-95f8-1fd90a74c428)


### 4. Role Hierarchy BEST PRACTICE

#### (1) Example
![스크린샷 2023-11-28 오후 6 08 38](https://github.com/SeongjaeHuh/snowflake/assets/52474199/f7bea993-5c67-4619-8c3f-bfc5ab26b8ac)

#### (2) Diagram
![스크린샷 2023-11-28 오후 6 07 25](https://github.com/SeongjaeHuh/snowflake/assets/52474199/399d9a37-4e17-4764-a82a-0c168b6388d5)

### 5. DDL
#### (1) As a user administrator (user with the USERADMIN role) or another role with the CREATE ROLE privilege on the account, create the access roles and functional roles in this example:

```sql
USE ROLE USERADMIN; 

CREATE ROLE db_hr_r;
CREATE ROLE db_fin_r;
CREATE ROLE db_fin_rw;
CREATE ROLE accountant;
CREATE ROLE analyst;
```

#### (2) As a security administrator (user with the SECURITYADMIN role) or another role with the MANAGE GRANTS privilege on the account, grant the required minimum permissions to each of the access roles:

```sql
USE ROLE SECURITYADMIN;

-- Grant read-only permissions on database HR to db_hr_r role.
GRANT USAGE ON DATABASE hr TO ROLE db_hr_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE hr TO ROLE db_hr_r;
GRANT SELECT ON ALL TABLES IN DATABASE hr TO ROLE db_hr_r;

-- Grant read-only permissions on database FIN to db_fin_r role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_r;
GRANT SELECT ON ALL TABLES IN DATABASE fin TO ROLE db_fin_r;

-- Grant read-write permissions on database FIN to db_fin_rw role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_rw;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_rw;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN DATABASE fin TO ROLE db_fin_rw;
```
```sql
-- Grant ownership on database FIN to db_fin_rw role.
GRANT OWNERSHIP ON DATABASE FIN TO ROLE db_fin_adm;
GRANT ALL PRIVILEGES ON DATABASE FIN TO ROLE db_fin_adm;
```

#### (3) As a security administrator (user with the SECURITYADMIN role) or another role with the MANAGE GRANTS privilege on the account, grant the db_fin_rw access role to the accountant functional role, and grant the db_hr_r db_fin_r access roles to the analyst functional role:
```sql
USE ROLE SECURITYADMIN;

GRANT ROLE db_fin_rw TO ROLE accountant;
GRANT ROLE db_hr_r TO ROLE analyst;
GRANT ROLE db_fin_r TO ROLE analyst;
```
#### (4) As a security administrator (user with the SECURITYADMIN role) or another role with the MANAGE GRANTS privilege on the account, grant both the analyst and accountant roles to the system administrator (SYSADMIN) role:

```sql
GRANT ROLE accountant,analyst TO ROLE sysadmin;
```
#### (5) As a security administrator (user with the SECURITYADMIN role) or another role with the MANAGE GRANTS privilege on the account, grant the business functional roles to the users who perform those business functions in your organization. In this example, the analyst functional role is granted to user user1, and the accountant functional role is granted to user user2.

```sql
USE ROLE SECURITYADMIN;

GRANT ROLE accountant TO USER user1;
GRANT ROLE analyst TO USER user2;
```

#### (6) Simplifying Grant Management Using Future Grants¶
```sql
USE ROLE SECURITYADMIN;

-- Grant the SELECT privilege on all new (i.e. future) tables in a schema to role R1
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r1;

-- / Create tables in the schema /

-- Grant the SELECT privilege on all new tables in a schema to role R2
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r2;

-- Grant the SELECT privilege on all existing tables in a schema to role R2
GRANT SELECT ON ALL TABLES IN SCHEMA s1 TO ROLE r2;

-- Revoke the SELECT privilege on all new tables in a schema (i.e. future grant) from role R1
REVOKE SELECT ON FUTURE TABLES IN SCHEMA s1 FROM ROLE r1;

-- Revoke the SELECT privilege on all existing tables in a schema from role R1
REVOKE SELECT ON ALL TABLES IN SCHEMA s1 FROM ROLE r1;
```
