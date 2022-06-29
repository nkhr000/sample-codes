--------- Userの表示 --------------------------
USE ROLE SECURITYADMIN;
SHOW USERS LIKE '%<word>%';

--------- Userの変更 --------------------------
-- https://docs.snowflake.com/ja/sql-reference/sql/alter-user.html
USE ROLE SECURITYADMIN;
ALTER USER IF EXISTS <username> SET 
    DEFAULT_WAREHOUSE = "WAREHOUSE WH_XSMALL"
    DEFAULT_ROLE = "COMPUTE_ROLE"
    TIMEZONE = 'Asia/Tokyo';  -- default: America/Los_Angeles

--------- MFAの設定 --------------------------
DESC USER <username>;

USE ROLE SECURITYADMIN;
ALTER USER IF EXISTS <username> SET DISABLE_MFA = TRUE;
