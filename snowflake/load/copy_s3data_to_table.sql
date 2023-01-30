USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
USE SCHEMA TEST_SCHEMA;

-- fileformat for JSON
create or replace file format jsonfileformat
    type = 'JSON'
    -- COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
    -- DATE_FORMAT = '<string>' | AUTO
    -- TIME_FORMAT = '<string>' | AUTO
    TIMESTAMP_FORMAT = 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM'
    TRIM_SPACE = TRUE 
    NULL_IF = ( '', 'null')
    STRIP_OUTER_ARRAY = TRUE -- Remove outer brackets (i.e. [])
;

-- fileformat for CSV
create or replace file format csvfileformat
    type = 'CSV'
    -- RECORD_DELIMITER = NONE
    FIELD_DELIMITER = NONE
    -- COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
    -- DATE_FORMAT = '<string>' | AUTO
    -- TIME_FORMAT = '<string>' | AUTO
    TIMESTAMP_FORMAT = 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM'
    TRIM_SPACE = TRUE 
    -- NULL_IF = ( '', 'null')
;

-- S3 Stage Integration
-- https://docs.snowflake.com/en/sql-reference/sql/create-storage-integration.html
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE STORAGE INTEGRATION s3_stage_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws accountid>:role/<aws rolename>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<allow path>/')
--   [ STORAGE_BLOCKED_LOCATIONS = ('<cloud>://<bucket>/<path>/', '<cloud>://<bucket>/<path>/') ]
;

-- Confirm External ID and Snowflake User ARN
DESC INTEGRATION s3_stage_integration;

-- Integrationの利用権限付与
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON INTEGRATION s3_stage_integration TO ROLE SYSADMIN;

-- 将来作成されるテーブルおよびStageの権限を付与
USE ROLE SYSADMIN;
GRANT ALL ON FUTURE TABLES IN SCHEMA TEST_DB.TEST_SCHEMA TO ROLE SYSADMIN;
GRANT USAGE ON FUTURE STAGES IN SCHEMA TEST_DB.TEST_SCHEMA  TO ROLE SYSADMIN;

-- Stage (External) for json
-- https://docs.snowflake.com/en/sql-reference/sql/create-stage.html
create or replace stage external_json_stage
    STORAGE_INTEGRATION = s3_stage_integration
    URL = 's3://<path to data>'
    file_format = jsonfileformat
;

-- Stage (External) for csv
-- https://docs.snowflake.com/en/sql-reference/sql/create-stage.html
create or replace stage external_csv_stage
    STORAGE_INTEGRATION = s3_stage_integration
    URL = 's3://<path to data>'
    file_format = csvfileformat
;

-- List S3 bucket
LIST @external_json_stage;

-- Create Table for csv (json)
USE SCHEMA TEST_DB.TEST_SCHEMA;
create or replace table csv_jsontable(
  copy_timestamp timestamp default current_timestamp(),
  json_string VARIANT
);


-- Create Table for json
USE SCHEMA TEST_DB.TEST_SCHEMA;
create or replace table jsontable(
  copy_timestamp timestamp default current_timestamp(),
  file_name VARCHAR,
  file_row_number VARCHAR,
  TS_DEVICE timestamp,
  TS_DEVICE_JST timestamp,
  SERVICE_ID VARCHAR(16777216),
  app_id Number(38, 0),
  BEACONS VARIANT,
  json_string VARIANT
);

-- Copy to Table
USE WAREHOUSE WH_XSMALL;
-- https://docs.snowflake.com/en/user-guide/data-load-transform.html
copy into jsontable(file_name, file_row_number, TS_DEVICE, TS_DEVICE_JST, SERVICE_ID, app_id, BEACONS, json_string)
  from (
    SELECT
      metadata$filename, 
      metadata$file_row_number,
      $1:tsDevice::Timestamp,
      CONVERT_TIMEZONE('UTC', 'Asia/Tokyo', $1:tsDevice),
      $1:serviceId,
      $1:apps.appId::Number,
      $1:beacons::VARIANT,
      $1::VARIANT
    FROM @external_json_stage t
  )
;

-- Copy to Table
USE WAREHOUSE WH_XSMALL;
-- https://docs.snowflake.com/en/user-guide/data-load-transform.html
copy into TEST_DB.TEST_SCHEMA.csv_jsontable(json_string)
  from (
    SELECT 
//        $1
      PARSE_JSON(REGEXP_REPLACE(REGEXP_REPLACE($1,'NumberLong\\(|\\)',''),'ISODate\\(|\\)',''))::VARIANT
    FROM @external_csv_stage t
  )
;


-- SELECT
SELECT * FROM jsontable;

-- Truncate table
TRUNCATE TABLE IF EXISTS jsontable;