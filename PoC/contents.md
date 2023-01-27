# 한림대 시연 시나리오 순서

## 1. (optional) Object 생성
### (1) DB, Schema, Table 생성 및 적재
### (2) Warehouse, User 생성

## 2. Data Sharing & Ext Table 구성
### (1) [기술검증](https://github.com/SeongjaeHuh/hallym/blob/main/PoC/1_ext_share.md)
### (2) [Table Loading](https://github.com/SeongjaeHuh/snowflake/blob/main/hallym/load_table_s3.md)
### (3) [Secure Data Sharing](https://github.com/SeongjaeHuh/hallym/blob/main/3_data_sharing.md)
### (4) [External Table 생성](https://github.com/SeongjaeHuh/hallym/blob/main/PoC/create_ext_table.md)

## 3. Data Governance
### (1) [RBAC](https://github.com/SeongjaeHuh/snowflake/blob/main/SG_create/role_hierarchy.md)
### (2) [Custom Role](https://github.com/SeongjaeHuh/snowflake/blob/main/SG_create/create_hybrid_role.md)
### (3) [Row-Level-Ctrl](https://github.com/SeongjaeHuh/snowflake/blob/main/hallym/row_level_access.md)
### (4) [Dynamic-Masking](https://github.com/SeongjaeHuh/hallym/blob/main/2_dynamic_masking.md)

## 4. 비용관리
### (1) [Resource Monitoring](https://github.com/SeongjaeHuh/snowflake/blob/main/SG_create/manage_account.md)
### (2) Warehouse 분리과금 : Custom Role 별 warehouse 분리되는 것. 3.(3)에 추가

## 5. 성능
### (1) Data 증폭 후 Query Execution
### (2) auto scale out case 
