---------------------------------------------------------------
-- 권한(prefix : A_) Role 생성
---------------------------------------------------------------
USE ROLE USERADMIN;

CREATE ROLE A_SC_[DB명_스키마명]_DBA;
CREATE ROLE A_SC_[DB명_스키마명]_ELT;
CREATE ROLE A_SC_[DB명_스키마명]_ANALYST;

--access_role
CREATE ROLE f_sc_[DB명_스키마명]_r;
CREATE ROLE f_sc_[DB명_스키마명]_rw;
CREATE ROLE f_sc_[DB명_스키마명]_adm;

grant role A_SC_[DB명_스키마명]_DBA to role sysadmin;
grant role A_SC_[DB명_스키마명]_ELT to role sysadmin;
grant role A_SC_[DB명_스키마명]_ANALYST to role sysadmin;
---------------------------------------------------------------
-- 기능 Role 생성
---------------------------------------------------------------
// F_SC_[DB명_스키마명]_ADM Role 생성: MY_DB DB 관련된 모든 권한 부여
USE ROLE SECURITYADMIN;

/* 모든 권한을 ro, rw, adm로 나눔 */
---------------------------------------------------------------
-- 기능(prefix : F)은 Role 생성
-- 1. 가장 상위 F_SC_[DB명_스키마명]_ADM
-- 2. 중위 F_SC_[DB명_스키마명]_RW
-- 3. 하위 F_SC_[DB명_스키마명]_RO
---------------------------------------------------------------

// 1. F_SC_[DB명_스키마명]_ADM 에 대한 권한 부여 (아래 건으로 대체됨)
   
/* GRANT OWNERSHIP ON SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM; */
GRANT ALL PRIVILEGES ON SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;

GRANT CREATE TABLE,
   CREATE VIEW,
   CREATE FILE FORMAT,
   CREATE STAGE,
   CREATE PIPE,
   CREATE TASK,
   CREATE SEQUENCE,
   CREATE FUNCTION,
   CREATE PROCEDURE ON SCHEMA [SCHEMA_NAME] 
TO ROLE F_SC_[DB명_스키마명]_ADM;

GRANT ALL ON FUTURE tables in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE views in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE file formats in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE stages in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE pipes in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE sequences in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE functions in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE procedures in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;
GRANT ALL ON FUTURE tasks in SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_ADM;


// 2. F_SC_[DB명_스키마명]_RW Role 생성: MY_DB 테이블 INSERT, UPDATE, DELETE 권한 부여 (table, view)
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RW;
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON FUTURE TABLES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RW;

GRANT INSERT, UPDATE, DELETE, TRUNCATE ON ALL views IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RW;
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON FUTURE views IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RW;


// 3. F_SC_[DB명_스키마명]_RO 생성: MY_DB 테이블, 뷰 SELECT 권한 부여, 그 외 INTEGRATION STORAGE, STAGE, FILE FORMAT, 특정 WAREHOUSE USAGE 권한 부여
GRANT SELECT ON ALL TABLES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT SELECT ON ALL VIEWS IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;

GRANT SELECT ON FUTURE TABLES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;

// 4.공통

--warehouse 등록
GRANT USAGE ON INTEGRATION hallym_s3_int TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON ALL STAGES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON ALL FILE FORMATS IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;

GRANT USAGE ON FUTURE STAGES IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;

GRANT USAGE ON WAREHOUSE XS_WH TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON WAREHOUSE S_WH TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON WAREHOUSE M_WH TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON WAREHOUSE L_WH TO ROLE F_SC_[DB명_스키마명]_RO;

/*상위 DB에 대한 */
GRANT USAGE ON database [DB_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;
GRANT USAGE ON SCHEMA [SCHEMA_NAME] TO ROLE F_SC_[DB명_스키마명]_RO;

/*필요에 따라 판단*/
GRANT IMPORTED PRIVILEGES ON DATABASE snowflake TO ROLE F_SC_[DB명_스키마명]_ADM;
/* REVOKE IMPORTED PRIVILEGES ON DATABASE snowflake FROM ROLE F_SC_[DB명_스키마명]_ADM; */



---------------------------------------------------------------
-- Role 간 관계 설정
---------------------------------------------------------------
USE ROLE SECURITYADMIN;

GRANT ROLE F_SC_[DB명_스키마명]_RO TO ROLE F_SC_[DB명_스키마명]_RW;
GRANT ROLE F_SC_[DB명_스키마명]_RW TO ROLE F_SC_[DB명_스키마명]_ADM;

GRANT ROLE F_SC_[DB명_스키마명]_RO TO ROLE A_SC_[DB명_스키마명]_ANALYST;
GRANT ROLE F_SC_[DB명_스키마명]_RW TO ROLE A_SC_[DB명_스키마명]_ELT;
GRANT ROLE F_SC_[DB명_스키마명]_ADM TO ROLE A_SC_[DB명_스키마명]_DBA;

GRANT ROLE A_SC_[DB명_스키마명]_ANALYST TO ROLE A_SC_[DB명_스키마명]_ELT;
GRANT ROLE A_SC_[DB명_스키마명]_ELT TO ROLE A_SC_[DB명_스키마명]_DBA;

--GRANT ROLE A_SC_[DB명_스키마명]_ANALYST TO ROLE A_SC_[DB명_스키마명]_DBA; -- OPTIONAL
GRANT ROLE A_SC_[DB명_스키마명]_DBA TO ROLE SYSADMIN;

---------------------------------------------------------------
-- User에 Role 부여
---------------------------------------------------------------
GRANT ROLE A_SC_[DB명_스키마명]_DBA TO USER HLADMIN;
