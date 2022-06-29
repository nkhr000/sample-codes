USE ROLE SYSADMIN;
USE SCHEMA TEST_DB.TEST_SCHEMA;

-- Create External Stage
create or replace stage external_json_snowpipe_stage
    STORAGE_INTEGRATION = s3_stage_integration
    URL = 's3://<path to data>'
    file_format = jsonfileformat
;

-- List S3 bucket
LIST @external_json_stage;

-- Create Table
USE SCHEMA TEST_DB.TEST_SCHEMA;
create or replace table jsontable_for_snowpipe(
    copy_timestamp timestamp default current_timestamp(),
    TS_DEVICE timestamp,
    TS_DEVICE_JST timestamp,
    SERVICE_ID VARCHAR(16777216),
    app_id Number(38, 0),
    BEACONS VARIANT,
    json_string VARIANT
);

-- Create Pipe
CREATE OR REPLACE PIPE loadpipe 
    AUTO_INGEST=TRUE  
    -- AWS_SNS_TOPIC = string
    AS
        copy into jsontable_for_snowpipe(TS_DEVICE, TS_DEVICE_JST, SERVICE_ID, app_id, BEACONS, json_string)
        from (
            SELECT
                $1:tsDevice,
                CONVERT_TIMEZONE('UTC', 'Asia/Tokyo', $1:tsDevice),
                $1:serviceId,
                $1:apps.appId::Number,
                $1:beacons::VARIANT,
                $1::VARIANT
            FROM @external_json_snowpipe_stage t
        )
        -- ON_ERROR = ABORT_STATEMENT
        -- SIZE_LIMIT = <num>
        -- file_format = (type = 'JSON')
;

-- PIPEの自動実行をOFFにする
ALTER PIPE IF EXISTS TEST_DB.TEST_SCHEMA.loadpipe SET PIPE_EXECUTION_PAUSED = TRUE;

-- Roleの作成
USE ROLE SECURITYADMIN;
CREATE OR REPLACE ROLE snowpipe_role;
grant role snowpipe_role to ROLE SYSADMIN;

grant usage on database TEST_DB to role snowpipe_role;
grant usage on schema TEST_DB.TEST_SCHEMA to role snowpipe_role;
grant insert, select on TEST_DB.TEST_SCHEMA.jsontable_for_snowpipe to role snowpipe_role;
grant usage on stage TEST_DB.TEST_SCHEMA.external_json_snowpipe_stage to role snowpipe_role;

-- Grant the OWNERSHIP privilege on the pipe object
USE ROLE SYSADMIN;
grant ownership on pipe TEST_DB.TEST_SCHEMA.loadpipe to role snowpipe_role;

-- PIPE USAGE HISTORY
-- https://docs.snowflake.com/en/user-guide/data-load-snowpipe-billing.html