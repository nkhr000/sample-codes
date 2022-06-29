USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
USE SCHEMA gov;
USE WAREHOUSE WH_XSMALL;

-- Create tag_damin
USE ROLE SECURITYADMIN;
CREATE ROLE TAG_ADMIN;
GRANT ROLE TAG_ADMIN TO ROLE SYSADMIN;

USE ROLE SYSADMIN;
GRANT CREATE TAG ON SCHEMA gov TO ROLE TAG_ADMIN;
GRANT APPLY TAG ON ACCOUNT TO ROLE TAG_ADMIN;
grant USAGE on database TEST_DB to role TAG_ADMIN;
grant USAGE, CREATE TABLE on schema TEST_DB.gov to role TAG_ADMIN;

-- Create Tag
USE ROLE TAG_ADMIN;
USE SCHEMA gov;
CREATE TAG usage_type;
CREATE TAG data_type;
CREATE TAG env;

SHOW TAGS IN SCHEMA gov;

-- Attach Tag to exist warehouse
USE ROLE SYSADMIN;
ALTER WAREHOUSE WH_XSMALL SET TAG usage_type = 'personal';

-- Attach Tag to Table
USE ROLE SYSADMIN; 
USE DATABASE TEST_DB;
CREATE OR REPLACE TABLE gov.test (
    id Integer, 
    v1 VARCHAR WITH TAG data_type = 'sensitive'
) 
WITH TAG (usage_type = 'personal', usage_type = 'test', env = 'test')
AS SELECT column1, column2 FROM VALUES (1, 'aaa'), (2, 'bbb'), (3, 'ccc');

CREATE OR REPLACE TABLE gov.test_c1 (id Integer) AS SELECT id FROM gov.test;


-- Tag list 
-- TAGS View: https://docs.snowflake.com/en/sql-reference/account-usage/tags.html
select * from snowflake.account_usage.tags
order by tag_name;

-- TagとObjectの参照関係
-- https://docs.snowflake.com/en/sql-reference/account-usage/tag_references.html
select * from snowflake.account_usage.tag_references
order by tag_name, domain, object_id;


USE DATABASE TEST_DB;
USE SCHEMA gov;
-- TAG KeyがtestのTable一覧
select * from table(information_schema.tag_references('test', 'TABLE'));
-- TAG KeyがtestのTABLEとカラム両方
SELECT * FROM table(information_schema.tag_references('test.v1', 'COLUMN'));

-- tag lineage
select *
from table(snowflake.account_usage.tag_references_with_lineage('TEST_DB.gov.usage_type'));
select system$get_tag('usage_type', 'test', 'table');

-- Creanup
DROP TABLE gov.test;
DROP TAG IF EXISTS usage_type, env, data_type;
