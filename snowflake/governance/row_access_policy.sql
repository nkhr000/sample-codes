USE ROLE SYSADMIN;
USE DATABASE TEST_DB;
USE SCHEMA TEST_DB.gov;
USE WAREHOUSE WH_XSMALL;

-- Create Table
CREATE TABLE gov.test_data (
    product_id varchar,
    product_name varchar,
    region varchar
);
insert into gov.test_data
    values
        ('P111','P111-name','Tokyo'),
        ('P111','P111-name','Fukuoka'),
        ('P222','P222-name','Tokyo'),
        ('P333','P333-name','Tokyo'),
        ('','-name','Tokyo')
;

CREATE TABLE gov.mapping (
    product_owner varchar,
    product_id varchar
);
insert into gov.mapping
    values
        ('TEST_1_ROLE','P111'),  -- TEST_1_ROLEロールはP111のproduct_idのみ参照可
        ('TEST_2_ROLE','P222'),
        ('TEST_3_ROLE','P333')
;

USE ROLE securityadmin;
CREATE ROLE TEST_1_ROLE;
CREATE ROLE TEST_2_ROLE;
CREATE ROLE TEST_3_ROLE;

CREATE ROLE mapping_role;
grant create row access policy on schema TEST_DB.gov to role mapping_role;
grant apply row access policy on account to role mapping_role;

GRANT ROLE TEST_1_ROLE TO ROLE SYSADMIN;
GRANT ROLE TEST_2_ROLE TO ROLE SYSADMIN;
GRANT ROLE TEST_3_ROLE TO ROLE SYSADMIN;
GRANT ROLE mapping_role TO ROLE SYSADMIN;

USE ROLE SYSADMIN;
grant USAGE on database TEST_DB to role mapping_role;
grant USAGE on database TEST_DB to role TEST_1_ROLE;
grant USAGE on database TEST_DB to role TEST_2_ROLE;
grant USAGE on database TEST_DB to role TEST_3_ROLE;
grant USAGE on schema TEST_DB.gov to role mapping_role;
grant USAGE on schema TEST_DB.gov to role TEST_1_ROLE;
grant USAGE on schema TEST_DB.gov to role TEST_2_ROLE;
grant USAGE on schema TEST_DB.gov to role TEST_3_ROLE;
grant select on table TEST_DB.gov.mapping to role mapping_role;

grant USAGE on schema TEST_DB.gov to role TEST_1_ROLE;
grant USAGE on schema TEST_DB.gov to role TEST_2_ROLE;
grant USAGE on schema TEST_DB.gov to role TEST_3_ROLE;
grant SELECT on table TEST_DB.gov.test_data to role TEST_1_ROLE;
grant SELECT on table TEST_DB.gov.test_data to role TEST_2_ROLE;
grant SELECT on table TEST_DB.gov.test_data to role TEST_3_ROLE;

GRANT ALL ON WAREHOUSE WH_XSMALL TO ROLE TEST_1_ROLE;
GRANT ALL ON WAREHOUSE WH_XSMALL TO ROLE TEST_2_ROLE;
GRANT ALL ON WAREHOUSE WH_XSMALL TO ROLE TEST_3_ROLE;


USE ROLE SYSADMIN;
create or replace row access policy TEST_DB.gov.product_policy as (product varchar) returns boolean ->
    'SYSADMIN' = current_role()
    or exists (
        select 1 from gov.mapping
        where product_owner = current_role()
        and product_id = product
    )
;

grant ownership on row access policy TEST_DB.gov.product_policy  to mapping_role;
grant all on row access policy TEST_DB.gov.product_policy  to SYSADMIN;

alter table TEST_DB.gov.test_data add row access policy TEST_DB.gov.product_policy on (product_id);

-- Usage
use role SYSADMIN;
select * from TEST_DB.gov.test_data;

use role TEST_1_ROLE;
USE WAREHOUSE WH_XSMALL;
select * from TEST_DB.gov.test_data;

use role TEST_2_ROLE;
USE WAREHOUSE WH_XSMALL;
select * from TEST_DB.gov.test_data;

use role TEST_3_ROLE;
USE WAREHOUSE WH_XSMALL;
select * from TEST_DB.gov.test_data;

-- Cleanup
use role securityadmin;
DROP ROLE TEST_1_ROLE;
DROP ROLE TEST_2_ROLE;
DROP ROLE TEST_3_ROLE;
DROP ROLE mapping_role;

use role SYSADMIN;
DROP TABLE TEST_DB.gov.test_data;
DROP TABLE TEST_DB.gov.mapping;

use role accountadmin;
Drop row access policy security.product_policy;