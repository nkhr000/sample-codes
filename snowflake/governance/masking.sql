
-- Masking
-- https://docs.snowflake.com/en/user-guide/security-column-ddm-intro.html
-- https://docs.snowflake.com/en/user-guide/security-column-intro.html


-- Create policy admin
USE ROLE SECURITYADMIN;
CREATE ROLE masking_admin;
GRANT ROLE masking_admin TO ROLE SYSADMIN;


-- [CREATE MASKING]の実行権限をmasking_adminに付与
USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
USE SCHEMA gov;
GRANT CREATE MASKING POLICY ON SCHEMA gov TO ROLE masking_admin;

-- [APPLY MASKING POLICY]の実行権限をmasking_adminに付与
USE ROLE ACCOUNTADMIN;
GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE masking_admin;

-- Database/Schemaの利用権限を付与
USE ROLE SYSADMIN;
grant USAGE on database TEST_DB to role masking_admin;
grant USAGE on schema TEST_DB.gov to role masking_admin;

-- Create Table
USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
USE WAREHOUSE WH_XSMALL;
CREATE OR REPLACE TABLE gov.masking_test (
    id INTEGER, 
    sensitive_data VARCHAR, 
    sensitive_time TIMESTAMP, 
    src VARIANT,
    encrypted_data BINARY) 
AS SELECT column1, column1, column3::timestamp_ntz, parse_json(column4), encrypt(column5, '<passphrase>')
FROM VALUES (1, 'deny KAG group', '2021-10-01', '{"data": "sensitive"}', 'important data1'), 
            (2, 'allow ABA group, CC group', '2021-10-01', '{"data":"important"}', 'important data2'), 
            (3, 'deny MMMMM group', '2021-10-02', '{"data":"daiji"}', 'important data3')
;

SELECT * FROM gov.masking_test ;

-- Encrypt function: https://docs.snowflake.com/en/sql-reference/functions/encrypt.html
-- AES-256

-- Create Masking policy
USE ROLE masking_admin;
CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_gen 
AS (val string) RETURNS string -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('TEST_ROLE_SENSITIVE_OK') THEN val
        ELSE '*********'
    END
;

CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_sha2
AS (val string) RETURNS string -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('TEST_ROLE_SENSITIVE_OK') THEN sha2(val)
        ELSE '*********'
    END
;

CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_timesamp
AS (val TIMESTAMP) RETURNS TIMESTAMP -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('TEST_ROLE_SENSITIVE_OK') THEN val
        ELSE date_from_parts(0001, 01, 01)::timestamp_ntz
    END
;

CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_variant
AS (val VARIANT) RETURNS VARIANT -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('TEST_ROLE_SENSITIVE_OK') THEN val
        ELSE object_insert(val, 'data', '****', true)
    END
;

CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_decrypt
AS (val BINARY) RETURNS BINARY -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('TEST_ROLE_SENSITIVE_OK') THEN decrypt(val, '<passphrase>')
        ELSE val
    END
;

-- use entitlement table
USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
CREATE OR REPLACE TABLE gov.entitlement (role_name VARCHAR, can_read BOOLEAN) AS 
SELECT column1, column2 FROM 
VALUES ('TEST_ROLE_SENSITIVE_OK', true), ('test_role_sensitive_ng', false)
;

GRANT SELECT ON TABLE gov.entitlement TO ROLE masking_admin;
USE ROLE masking_admin;
CREATE OR REPLACE MASKING POLICY gov.sensitive_comment_mask_usetable
AS (val string) RETURNS string -> 
    CASE 
        WHEN EXISTS (SELECT 1 FROM gov.entitlement WHERE can_read and role_name = CURRENT_ROLE()) THEN val
        ELSE '*********'
    END
;

-- Apply to table
USE ROLE masking_admin;
ALTER TABLE IF EXISTS gov.masking_test MODIFY COLUMN sensitive_data SET MASKING POLICY gov.sensitive_comment_mask_gen;
-- ALTER TABLE IF EXISTS gov.masking_test MODIFY COLUMN sensitive_data UNSET MASKING POLICY;

-- CREATE TEST ROLE
USE ROLE SECURITYADMIN;
CREATE OR REPLACE ROLE test_role_sensitive_ok;
CREATE OR REPLACE ROLE test_role_sensitive_ng;
GRANT ROLE test_role_sensitive_ok TO ROLE SYSADMIN;
GRANT ROLE test_role_sensitive_ng TO ROLE SYSADMIN;

USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
GRANT USAGE ON DATABASE TEST_DB TO ROLE test_role_sensitive_ok;
GRANT USAGE ON DATABASE TEST_DB TO ROLE test_role_sensitive_ng;
GRANT USAGE ON SCHEMA TEST_DB.gov TO ROLE test_role_sensitive_ok;
GRANT USAGE ON SCHEMA TEST_DB.gov TO ROLE test_role_sensitive_ng;
GRANT SELECT ON TABLE TEST_DB.gov.masking_test TO ROLE test_role_sensitive_ok;
GRANT SELECT ON TABLE TEST_DB.gov.masking_test TO ROLE test_role_sensitive_ng;

GRANT USAGE ON WAREHOUSE WH_XSMALL TO ROLE test_role_sensitive_ok;
GRANT USAGE ON WAREHOUSE WH_XSMALL TO ROLE test_role_sensitive_ng;

-- Usage
USE ROLE SYSADMIN; 
SELECT * FROM TEST_DB.gov.masking_test

USE ROLE test_role_sensitive_ok; 
SELECT * FROM TEST_DB.gov.masking_test

USE ROLE test_role_sensitive_ng; 
SELECT * FROM TEST_DB.gov.masking_test

-- CleanUp
USE ROLE ACCOUNTADMIN;
USE DATABASE TEST_DB;
DROP TABLE gov.masking_test;
DROP TABLE gov.entitlement;

DROP MASKING POLICY gov.sensitive_comment_mask_gen;
DROP MASKING POLICY gov.sensitive_comment_mask_sha2;
DROP MASKING POLICY gov.sensitive_comment_mask_timesamp;
DROP MASKING POLICY gov.sensitive_comment_mask_variant;
DROP MASKING POLICY gov.sensitive_comment_mask_decrypt;
DROP MASKING POLICY gov.sensitive_comment_mask_usetable;

DROP ROLE test_role_sensitive_ok;
DROP ROLE test_role_sensitive_ng;
DROP ROLE masking_admin;
