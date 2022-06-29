
--------- Role作成 --------------------------------------
USE ROLE SECURITYADMIN;
CREATE ROLE COMPUTE_ROLE;
GRANT ROLE COMPUTE_ROLE TO ROLE SYSADMIN;
GRANT ROLE COMPUTE_ROLE TO USER <username>;

--------- ORGADMIN権限の付与 -----------------------------
USE ROLE SECURITYADMIN;
CREATE ROLE SECURITY_ROLE;
GRANT ROLE SECURITY_ROLE TO ROLE SECURITYADMIN;
GRANT ROLE SECURITY_ROLE TO USER <username>;
GRANT ROLE ORGADMIN TO SECURITY_ROLE;

--------- Roleの削除 --------------------------------------
DROP ROLE <role name>

--------- Warehouse利用権限の付与 --------------------------
GRANT USAGE ON WAREHOUSE WH_XSMALL TO ROLE COMPUTE_ROLE;
GRANT USAGE ON WAREHOUSE WH_XSMALL TO ROLE SECURITY_ROLE;

--------- DB/Schema利用権限の付与 --------------------------
USE ROLE SYSADMIN;
GRANT USAGE ON DATABASE TEST_DB TO ROLE COMPUTE_ROLE; 
GRANT ALL ON DATABASE TEST_DB TO ROLE COMPUTE_ROLE; 
GRANT ALL ON SCHEMA TEST_DB.TEST_SCHEMA TO ROLE COMPUTE_ROLE;
GRANT ALL ON future tables IN schema TEST_DB.TEST_SCHEMA TO ROLE COMPUTE_ROLE;

--------- Ownership Roleの変更 -----------------------------
SELECT 'grant ownership on table ' || table_name || ' to role <new_role> copy current grants;' 
AS grant_statement
FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES 
WHERE grantor = '<old_grant_role>';
