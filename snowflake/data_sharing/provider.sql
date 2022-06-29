
USE ROLE ACCOUNTADMIN;
CREATE ROLE data_share_admin;
GRANT ROLE data_share_admin TO ROLE SYSADMIN;

-------- Create Shareの実行権限を作成Roleに付与 -------------
GRANT create share on account to data_share_admin;

-------- DB管理者権限に変更しSchemaおよびViewの作成 -----------
USE ROLE db_admin;
USE DATABASE TEST_DB;
CREATE SCHEMA tests;
CREATE TABLE tests.rowtable (id INTEGER, custumer_id VARCHAR, name VARCHAR)
AS 
    SELECT column1, column2, column3
    FROM 
    VALUES  (1, 'A123456', 'ABC Corp'), 
            (2, 'B123456', 'BB Corp'), 
            (3, 'C123456', 'CC Corp'),
            (4, 'A123456', 'ABC2 Corp'), 
            (5, 'A123456', 'ABC3 Corp'), 
            (6, 'C123456', 'CC Corp')
;

CREATE SECURE VIEW tests.shareview (id, name) 
AS 
    SELECT id, name 
    FROM tests.rowtable
    WHERE custumer_id = 'A123456' 

CREATE SECURE VIEW tests.shareview2 (id, name) 
AS 
    SELECT id, name 
    FROM tests.rowtable
    WHERE customer_id = 'C123456' 

--- Create Share
USE ROLE data_share_admin;
CREATE SHARE share1;

--- Share object利用権限の付与
--- 複数DatabaseからViewを作っている場合は、それらのDBに対してreference_usage権限が必要
USE ROLE db_admin;
GRANT USAGE ON DATABASE TEST_DB TO SHARE share1;
GRANT USAGE ON SCHEMA TEST_DB.tests TO SHARE share1;
GRANT SELECT ON TABLE TEST_DB.tests.shareview TO SHARE share1;

-- Share to other account
show grants to share share1;
alter share share1 add accounts=<account>;

-- test share
use role accountadmin;
alter session set simulated_data_sharing_consumer=<account>;

-- See who created database from share
SHOW SHARES LIKE 'share1';
show grants of share share1;

