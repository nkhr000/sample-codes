-- Snowflakeが持つRegion一覧を表示
SHOW REGIONS;

-------- ROLE: [ORGADMIN] Activate ------------------------
use role accountadmin;
grant role orgadmin to user <user_name>;
grant role orgadmin to role <role_name>;

-- Create new organization account ------------------------
USE ROLE ORGADMIN;
CREATE ACCOUNT SHARE_ORG
    ADMIN_NAME = YourAdminName
    ADMIN_PASSWORD = YourAdminPassword
    FIRST_NAME = YourFirstName
    LAST_NAME = YourLastName
    EMAIL = youremail@yourdomain.com
    EDITION = ENTERPRISE
    REGION = aws_ap_northeast_1;

USE ROLE ORGADMIN;
SHOW ORGANIZATION ACCOUNTS LIKE 'SHARE_ORG';

-------- ACCOUNT PARAMETERS ------------------------
--  SHOW ACCOUNT Parameters >SHOW PARAMETERS [ LIKE '<pattern>' ] IN ACCOUNT
--  https:docs.snowflake.com/ja/sql-reference/parameters.html#
--  SHOW PARAMETERS [ LIKE '<pattern>' ]
--  [ { IN | FOR } { SESSION | ACCOUNT | USER <name> | { WAREHOUSE | DATABASE | SCHEMA | TASK } [ <name> ] 
--  | TABLE <table_name> } ]
SHOW PARAMETERS LIKE '%TIMESTAMP%' IN ACCOUNT;

--  Alter account (パラメータをクリアする場合はALTER ACCOUNT UNSET)
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET TIMEZONE = 'Asia/Tokyo'


-------- RESOURCE MONITOR ------------------------
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET RESOURCE_MONITOR = <monitor_name>


-------- Create Base Resource ------------------------
USE ROLE USERADMIN;
CREATE ROLE dbt_role;

USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE DBT;
CREATE OR REPLACE SCHEMA DBT.DEV;
GRANT ROLE dbt_role to user <username>;
GRANT ROLE dbt_role to role sysadmin;
GRANT USAGE, CREATE SCHEMA ON DATABASE dbt TO ROLE dbt_role;
GRANT OWNERSHIP ON SCHEMA dbt.dev to role dbt_role REVOKE CURRENT GRANTS;

CREATE OR REPLACE WAREHOUSE DBT_XSMALL WITH
warehouse_size='XSMALL'
MAX_CLUSTER_COUNT=1
MIN_CLUSTER_COUNT=1
SCALING_POLICY=ECONOMY
AUTO_SUSPEND=60
AUTO_RESUME=TRUE
INITIALLY_SUSPENDED=TRUE
;
GRANT USAGE ON WAREHOUSE DBT_XSMALL TO ROLE dbt_role;

USE ROLE USERADMIN;
CREATE OR REPLACE USER dbt_deploy
    DEFAULT_WAREHOUSE = DBT_XSMALL
    PASSWORD = '<password>'
    DEFAULT_ROLE = dbt_role
    TIMEZONE = 'Asia/Tokyo'  -- default: America/Los_Angeles
    COMMENT = 'dbt cloud deploy user';

GRANT ROLE dbt_role TO USER dbt_deploy;

-- -------- READER ACCOUNT ------------------------
--  Reader (Managed) Account
--  https:docs.snowflake.com/ja/user-guide/data-sharing-reader-create.html
USE ROLE ACCOUNTADMIN;
GRANT CREATE ACCOUNT ON ACCOUNT TO ROLE INTERNAL_SECURITY_ROLE

USE ROLE INTERNAL_SECURITY_ROLE
create managed account reader_acct1
    admin_name = reader_user_admin 
    admin_password = '<password>'
    type = reader;

SHOW MANAGED ACCOUNTS LIKE 'reader_acc1'

-- 削除 (Reader Account Delete)
DROP MANAGED ACCOUNT "READER_ACCT1";
