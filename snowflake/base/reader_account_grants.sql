USE ROLE SECURITYADMIN;

-- admin role
CREATE OR REPLACE ROLE CLIENTADMIN COMMENT = 'Client Administrator Role';

-- viewer role
CREATE OR REPLACE ROLE CLIENTVIEWER COMMENT = 'Client Viewer Role';
GRANT ROLE CLIENTVIEWER TO ROLE SYSADMIN;

-- data access role
CREATE OR REPLACE ROLE DATAACCESS COMMENT = 'data access role';
GRANT ROLE DATAACCESS TO ROLE CLIENTVIEWER;

-- warehouse access role
CREATE OR REPLACE ROLE WHACCESS COMMENT = 'warehouse access role';
GRANT ROLE WHACCESS TO ROLE CLIENTVIEWER;

-- create admin user
CREATE USER IF NOT EXISTS client_admin
    DEFAULT_ROLE = CLIENTADMIN
    TIMEZONE = 'Asia/Tokyo'
    EMAIL = '<email>'
    MUST_CHANGE_PASSWORD = TRUE
    PASSWORD = '<password>'
    COMMENT = 'client administrator user';
    
GRANT ROLE CLIENTADMIN TO USER client_admin; 
GRANT ROLE CLIENTVIEWER TO USER client_admin;

-- grant user creation
-- readerアカウント内でclientadmin roleでユーザ作成ができるようにする
GRANT CREATE USER ON ACCOUNT TO ROLE CLIENTADMIN;

USE ROLE SYSADMIN;
-- create warehouse
CREATE OR REPLACE WAREHOUSE reader_wh WITH
    warehouse_size='XSMALL'
    MAX_CLUSTER_COUNT=1
    AUTO_SUSPEND=60   
    AUTO_RESUME=TRUE   
    INITIALLY_SUSPENDED=TRUE;
    
GRANT USAGE,OPERATE,MONITOR ON WAREHOUSE reader_wh TO ROLE WHACCESS;

-- create shared db
USE ROLE ACCOUNTADMIN;
CREATE DATABASE shared_db FROM SHARE <Provider Account Locator>.shared_db;
GRANT IMPORTED PRIVILEGES ON DATABASE shared_db TO ROLE DATAACCESS;

-- create viewer user
USE ROLE CLIENTADMIN;
CREATE USER IF NOT EXISTS viewer_user
    DEFAULT_ROLE = CLIENTVIEWER
    DEFAULT_WAREHOUSE = reader_wh
    TIMEZONE = 'Asia/Tokyo'
    EMAIL = '<email>'
    MUST_CHANGE_PASSWORD = TRUE
    PASSWORD = '<password>'
    COMMENT = 'client user';
    
GRANT ROLE CLIENTVIEWER TO USER viewer_user; 

-- confirmation
USE ROLE CLIENTVIEWER;
USE WAREHOUSE reader_wh;
SELECT * FROM shared_db.shared_schema.shared_table;
