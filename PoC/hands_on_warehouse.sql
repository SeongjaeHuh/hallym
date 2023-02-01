----------------------------------------------------------
----------------------------------------------------------
-- 파일 명: hands_on_warehouse.sql
-- 실습 명: Warehouse 생성 및 활용
-- 주의: [USER00] => 할당받은 로그인ID로 변경 필요 (예를들면, USER00)
----------------------------------------------------------
----------------------------------------------------------

--  Warehouse 생성
CREATE OR REPLACE WAREHOUSE [USER00]_WH 
WAREHOUSE_SIZE = 'SMALL' 
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 2 
INITIALLY_SUSPENDED = TRUE
SCALING_POLICY = 'STANDARD'
COMMENT = 'user00 warehouse';

SHOW WAREHOUSES LIKE '[USER00]_WH%';

-- Warehouse 속성 수정	
ALTER WAREHOUSE [USER00]_WH SET
WAREHOUSE_SIZE ='XSMALL'
AUTO_SUSPEND = 300
MAX_CLUSTER_COUNT = 1;

SHOW WAREHOUSES LIKE '[USER00]_WH%'; 

-- Warehouse RESUME 
ALTER WAREHOUSE [USER00]_WH RESUME;

SHOW WAREHOUSES LIKE '[USER00]_WH%'; 
					
-- 쿼리 수행 				 	 						
SELECT * 
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."SUPPLIER"
LIMIT 10
; 

-- Warehouse SUSPEND 
ALTER WAREHOUSE [USER00]_WH SUSPEND;

SHOW WAREHOUSES LIKE '[USER00]_WH%'; 

