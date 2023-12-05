
-- condition_occurrence definition
CREATE TABLE condition_occurrence (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  condition_occurrence_id NUMBER(20) NOT NULL COMMENT '진단생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  condition_concept_id NUMBER(20) DEFAULT NULL COMMENT '진단표준ID',
  condition_start_date date DEFAULT NULL COMMENT '진단시작일자',
  condition_start_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '진단시작일시',
  condition_end_date date DEFAULT NULL COMMENT '진단종료일자',
  condition_end_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '진단종료일시',
  condition_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '진단자료유형표준ID',
  condition_status_concept_id NUMBER(20) DEFAULT NULL COMMENT '진단상태표준ID',
  stop_reason varchar(20) DEFAULT NULL COMMENT '중단이유',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '내원기록ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '내원상세기록ID',
  condition_source_value varchar(50) DEFAULT NULL COMMENT '원자료진단코드값',
  condition_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료진단표준ID',
  condition_status_source_value varchar(50) DEFAULT NULL COMMENT '원자료진단상태값',
  DX varchar(255) DEFAULT NULL COMMENT 'KCD코드',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  del_yn varchar(1) DEFAULT NULL,
  constraint primary_key_1 PRIMARY KEY  (condition_occurrence_id,locate)
) COMMENT='진단정보';

-- death definition

CREATE TABLE death (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  person_id NUMBER(20) NOT NULL COMMENT '환자ID',
  death_date date DEFAULT NULL COMMENT '사망일자',
  death_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '사망일시',
  death_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '사망정보출처표준ID',
  cause_concept_id NUMBER(20) NOT NULL COMMENT '사망원인표준ID',
  cause_source_value varchar(300) DEFAULT NULL COMMENT '사망원인원내기록값',
  cause_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '사망원인원내기록표준ID',
  DX varchar(255) DEFAULT NULL COMMENT 'KCD코드',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (locate,person_id,cause_concept_id)
) COMMENT='사망정보';

-- drug_exposure definition

CREATE TABLE drug_exposure (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  drug_exposure_id NUMBER(20) NOT NULL COMMENT '약물노출생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  drug_concept_id NUMBER(20) DEFAULT NULL COMMENT '약물표준ID',
  drug_exposure_start_date date DEFAULT NULL COMMENT '약물노출시작일자',
  drug_exposure_start_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '약물노출시작일시',
  drug_exposure_end_date date DEFAULT NULL COMMENT '약물노출종료일자',
  drug_exposure_end_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '약물노출종료일시',
  verbatim_end_date date DEFAULT NULL COMMENT '실제약물노출종료일자',
  drug_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '약물자료유형표준ID',
  stop_reason varchar(20) DEFAULT NULL COMMENT '중단이유',
  refills NUMBER(20) DEFAULT NULL COMMENT '재처방횟수',
  quantity decimal(20,10) DEFAULT NULL COMMENT '처방용량',
  quantity_days decimal(20,10) DEFAULT NULL COMMENT '1일투여횟수',
  days_supply decimal(20,10) DEFAULT NULL COMMENT '처방일수',
  sig text DEFAULT NULL COMMENT '투약비고',
  route_concept_id NUMBER(20) DEFAULT NULL COMMENT '투여경로표준ID',
  lot_number varchar(50) DEFAULT NULL COMMENT '약품LOT번호',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '방문생성ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '방문상세ID',
  drug_source_value varchar(50) DEFAULT NULL COMMENT '원자료약물EDI코드',
  drug_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료약물표준ID',
  route_source_value varchar(50) DEFAULT NULL COMMENT '원자료투약경로',
  dose_unit_source_value varchar(50) DEFAULT NULL COMMENT '원자료투약단위',
  dc_yn varchar(1) DEFAULT NULL,
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (drug_exposure_id,locate)
) COMMENT='약물정보';

-- measurement definition

CREATE TABLE measurement (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  measurement_id NUMBER(20) NOT NULL COMMENT '검사생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  measurement_concept_id NUMBER(20) DEFAULT NULL COMMENT '검사명표준ID',
  measurement_date date DEFAULT NULL COMMENT '검사일자',
  measurement_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '검사일시',
  measurement_time varchar(10) DEFAULT NULL COMMENT '검사시간',
  measurement_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '검사자료유형표준ID',
  operator_concept_id NUMBER(20) DEFAULT NULL COMMENT '연산자표준ID',
  value_as_number decimal(20,10) DEFAULT NULL COMMENT '숫자형검사결과값',
  value_as_concept_id NUMBER(20) DEFAULT NULL COMMENT '검사결과표준ID',
  unit_concept_id NUMBER(20) DEFAULT NULL COMMENT '검사단위표준ID',
  range_low decimal(20,10) DEFAULT NULL COMMENT '정상범위하한값',
  range_high decimal(20,10) DEFAULT NULL COMMENT '정상범위상한값',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '방문생성ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '방문상세ID',
  measurement_source_value varchar(50) DEFAULT NULL COMMENT '원자료검사명',
  measurement_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료검사명표준ID',
  unit_source_value varchar(50) DEFAULT NULL COMMENT '원자료검사단위',
  unit_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료검사표준ID',
  value_source_value varchar(8000) DEFAULT NULL COMMENT '원자료검사결과값',
  measurement_event_id NUMBER(20) DEFAULT NULL COMMENT '측정이벤트ID',
  meas_event_field_concept_id NUMBER(20) DEFAULT NULL COMMENT '측정이벤트필드ID',
  LOINC varchar(20) DEFAULT NULL COMMENT 'LOINC코드',
  dc_yn varchar(1) DEFAULT NULL,
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (measurement_id,locate)
) COMMENT='검사정보';

-- note definition

CREATE TABLE note (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  note_id NUMBER(20) NOT NULL COMMENT '노트기록ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  note_date date DEFAULT NULL COMMENT '노트기록일자',
  note_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '노트기록일시',
  note_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '노트기록유형표준ID',
  note_class_concept_id NUMBER(20) DEFAULT NULL COMMENT '노트기록분류표준ID',
  note_title varchar(250) DEFAULT NULL COMMENT '노트기록제목',
  note_text text DEFAULT NULL COMMENT '노트기록내용',
  encoding_concept_id NUMBER(20) DEFAULT NULL COMMENT '문자인코딩ID',
  language_concept_id NUMBER(20) DEFAULT NULL COMMENT '언어ID',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '내원유형ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '내원상세기록ID',
  note_source_value varchar(50) DEFAULT NULL COMMENT '원자료노트기록값',
  note_event_id NUMBER(20) DEFAULT NULL COMMENT '노트기록이벤트ID',
  note_event_field_concept_id NUMBER(20) DEFAULT NULL COMMENT '노트기록이벤트필드ID',
  dc_yn varchar(1) DEFAULT NULL,
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (note_id,locate)
) COMMENT='노트기록';

-- observation definition

CREATE TABLE observation (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  observation_id NUMBER(20) NOT NULL COMMENT '관찰기록ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  observation_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰정보표준ID',
  observation_date date DEFAULT NULL COMMENT '관찰일자',
  observation_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '관찰일시',
  observation_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰정보출처표준ID',
  value_as_number decimal(20,5) DEFAULT NULL COMMENT '숫자형관찰결과값',
  value_as_string varchar(400) DEFAULT NULL COMMENT '문자형관찰결과값',
  value_as_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰결과값표준ID',
  qualifier_concept_id NUMBER(20) DEFAULT NULL COMMENT '입력자표준ID',
  unit_concept_id NUMBER(20) DEFAULT NULL COMMENT '단위표준ID',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '방문생성ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '방문상세ID',
  observation_source_value varchar(100) DEFAULT NULL COMMENT '관찰정보원내기록값',
  observation_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰정보원내기록값표준ID',
  unit_source_value varchar(50) DEFAULT NULL COMMENT '관찰정보단위_원내',
  qualifier_source_value varchar(50) DEFAULT NULL COMMENT '입력자정보_원내기록',
  value_source_value varchar(50) DEFAULT NULL COMMENT '관찰결과값_원내기록',
  observation_event_id NUMBER(20) DEFAULT NULL COMMENT '관찰이벤트ID',
  obs_event_field_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰이벤트필드ID',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (locate,observation_id)
) COMMENT='관찰기록';

-- observation_period definition

CREATE TABLE observation_period (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  observation_period_id NUMBER(20) NOT NULL COMMENT '관찰기간생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  observation_period_start_date date DEFAULT NULL COMMENT '관찰시작날짜',
  observation_period_end_date date DEFAULT NULL COMMENT '관찰종료날짜',
  period_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '관찰자료유형표준ID',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (locate,observation_period_id)
) COMMENT='관찰기간정보';

-- person definition

CREATE TABLE person (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  person_id NUMBER(20) NOT NULL COMMENT '환자ID',
  gender_concept_id NUMBER(20) DEFAULT NULL COMMENT '성별표준ID',
  year_of_birth number(11) DEFAULT NULL COMMENT '출생연도',
  month_of_birth number(11) DEFAULT NULL COMMENT '출생월',
  day_of_birth number(11) DEFAULT NULL COMMENT '출생일',
  birth_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '출생시간',
  race_concept_id NUMBER(20) DEFAULT NULL COMMENT '인종표준ID',
  ethnicity_concept_id NUMBER(20) DEFAULT NULL COMMENT '민족성표준ID',
  location_id NUMBER(20) DEFAULT NULL COMMENT '환자주소',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관명',
  care_site_id NUMBER(20) DEFAULT NULL COMMENT '의료기관주소',
  person_source_value varchar(50) DEFAULT NULL COMMENT '원자료환자식별값',
  gender_source_value varchar(50) DEFAULT NULL COMMENT '원자료환자성별값',
  gender_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료성별표준ID',
  race_source_value varchar(50) DEFAULT NULL COMMENT '원자료환자인종값',
  race_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료인종표준ID',
  ethnicity_source_value varchar(50) DEFAULT NULL COMMENT '원자료민족성값',
  ethnicity_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료민족성표준ID',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (locate,person_id)
) COMMENT='환자정보';

-- procedure_occurrence definition

CREATE OR REPLACE TABLE procedure_occurrence (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  procedure_occurrence_id NUMBER(20) NOT NULL COMMENT '처치수술생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  procedure_concept_id NUMBER(20) DEFAULT NULL COMMENT '처치수술표준ID',
  procedure_date date DEFAULT NULL COMMENT '처치수술일자',
  procedure_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '처치수술일시',
  procedure_end_date date DEFAULT NULL COMMENT '처치수술종료일자',
  procedure_end_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '처치수술종료일시',
  procedure_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '처치수술자료유형표준ID',
  modifier_concept_id NUMBER(20) DEFAULT NULL COMMENT '세부표준ID',
  quantity NUMBER(20) DEFAULT NULL COMMENT '처치수술시행수',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '방문생성ID',
  visit_detail_id NUMBER(20) DEFAULT NULL COMMENT '방문상세ID',
  procedure_source_value varchar(255) DEFAULT NULL COMMENT '원자료처치수술명',
  procedure_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료처치수술명표준ID',
  modifier_source_value varchar(50) DEFAULT NULL COMMENT '수정자원내기록값',
  EDI_code varchar(20) DEFAULT NULL COMMENT '처치수술EDI코드',
  dc_yn varchar(1) DEFAULT NULL,
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (procedure_occurrence_id,locate)
) COMMENT='처치정보';

-- visit_occurrence definition

CREATE TABLE visit_occurrence (
  locate varchar(10) NOT NULL COMMENT '병원구분',
  visit_occurrence_id NUMBER(20) NOT NULL COMMENT '방문생성ID',
  person_id NUMBER(20) DEFAULT NULL COMMENT '환자ID',
  visit_concept_id NUMBER(20) DEFAULT NULL COMMENT '방문표준ID',
  visit_start_date date DEFAULT NULL COMMENT '방문시작일자',
  visit_start_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '방문시작일시',
  visit_end_date date DEFAULT NULL COMMENT '방문종료일자',
  visit_end_datetime TIMESTAMP_NTZ DEFAULT NULL COMMENT '방문종료일시',
  visit_type_concept_id NUMBER(20) DEFAULT NULL COMMENT '방문자료유형표준ID',
  provider_id NUMBER(20) DEFAULT NULL COMMENT '의료기관ID',
  care_site_id NUMBER(20) DEFAULT NULL COMMENT '의료기관주소',
  visit_source_value varchar(50) DEFAULT NULL COMMENT '원자료방문유형',
  visit_source_concept_id NUMBER(20) DEFAULT NULL COMMENT '원자료방문표준ID',
  admitted_from_concept_id NUMBER(20) DEFAULT NULL COMMENT '입원전관리기관표준ID',
  admitted_from_source_value varchar(50) DEFAULT NULL COMMENT '입원전관리기관원내기록값',
  discharged_to_concept_id NUMBER(20) DEFAULT NULL COMMENT '퇴원후관리기관표준ID',
  discharged_to_source_value varchar(50) DEFAULT NULL COMMENT '퇴원후관리기관원내기록값',
  preceding_visit_occurrence_id NUMBER(20) DEFAULT NULL COMMENT '이전내원기록ID',
  etl_datetime TIMESTAMP_NTZ NOT NULL DEFAULT current_timestamp() COMMENT 'ETL등록일시',
  constraint primary_key_1 PRIMARY KEY  (locate,visit_occurrence_id)
) COMMENT='방문정보';

COPY into CONDITION_OCCURRENCE from @hallym.hallym.HALLYM_S3_STAGE/co/ FILE_FORMAT = (FORMAT_NAME= 'hallym.hallym.hallym_csv_format') ;
COPY into DEATH from @HALLYM_S3_STAGE/death/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into DRUG_EXPOSURE from @HALLYM_S3_STAGE/de/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into measurement from @HALLYM_S3_STAGE/m/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into note from @HALLYM_S3_STAGE/n/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into observation from @HALLYM_S3_STAGE/o/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into observation_period from @HALLYM_S3_STAGE/op/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into person from @HALLYM_S3_STAGE/p/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into procedure_occurrence from @HALLYM_S3_STAGE/po/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
COPY into visit_occurrence from @HALLYM_S3_STAGE/vo/ FILE_FORMAT = (FORMAT_NAME= 'hallym_csv_format') ;
