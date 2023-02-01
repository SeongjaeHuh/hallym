----------------------------------------------------------
----------------------------------------------------------
-- 파일 명: hands_on_unload.sql
-- 실습 명: SnowSQL로 Data Unloading
-- 주의: [USER00] => 할당받은 로그인ID로 변경 필요 (예를들면, USER00)
----------------------------------------------------------
----------------------------------------------------------

-- "Warehouse 생성 및 활용"에서 생성한 Warehouse와 EMPLOYEE 테이블 사용
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE [USER00]_WH;
USE DATABASE [USER00]_DB;

-- EMPLOYEE 데이터 확인
SELECT * FROM EMPLOYEE;

-- Unload할 때 사용할 FILE FORMAT 생성
CREATE OR REPLACE FILE FORMAT [USER00]_DB.PUBLIC.[USER00]_FILEFORMAT_UNLOAD
 TYPE = CSV
 COMPRESSION = NONE
 FIELD_DELIMITER = ','
 FILE_EXTENSION = 'CSV'
 SKIP_HEADER = 0 
;

DESC FILE FORMAT [USER00]_FILEFORMAT_UNLOAD;

-- 명명된 Internal Stage [USER00]_STAGE_UNLOAD 생성
CREATE OR REPLACE STAGE [USER00]_DB.PUBLIC.[USER00]_STAGE_UNLOAD
 FILE_FORMAT = [USER00]_FILEFORMAT_UNLOAD
;

-- [USER00]_STAGE_UNLOAD 정보
DESC STAGE [USER00]_STAGE_UNLOAD;

-- [USER00]_STAGE_UNLOAD에 파일 리스트 조회
LIST @[USER00]_STAGE_UNLOAD;

-- [USER00]_STAGE_UNLOAD에 EMPLOYEE 데이터 복사
COPY INTO @[USER00]_STAGE_UNLOAD
 FROM EMPLOYEE
FILE_FORMAT = (FORMAT_NAME = [USER00]_FILEFORMAT_UNLOAD)
;

-- [USER00]_STAGE_UNLOAD에 파일 리스트 조회
LIST @[USER00]_STAGE_UNLOAD;

-- [USER00]_STAGE_UNLOAD에 있는 데이터 조회
SELECT $1, $2, $3, $4
FROM @[USER00]_STAGE_UNLOAD
(FILE_FORMAT => "[USER00]_FILEFORMAT_UNLOAD")
;

-- C:\snowflake_data 폴더 로컬에 생성

-- 로컬 파일 경로로 [USER00]_STAGE_UNLOAD에 있는 파일 다운로드
GET @[USER00]_STAGE_UNLOAD file://C:\snowflake_data;


-- [USER00]_STAGE_UNLOAD에 있는 파일 삭제
REMOVE @[USER00]_STAGE_UNLOAD;

-- [USER00]_STAGE_UNLOAD에 파일 리스트 조회, 삭제됨을 확인
LIST @[USER00]_STAGE_UNLOAD;

-- [USER00]_STAGE_UNLOAD 삭제
DROP STAGE [USER00]_STAGE_UNLOAD;

-- SnowSQL 종료하기
!exit