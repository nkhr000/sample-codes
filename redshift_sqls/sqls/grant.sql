------------------------------------------
-- Create Schema AND Schema owner user
------------------------------------------
CREATE USER schema_admin WITH PASSWORD '<password>'

CREATE SCHEMA dev;
ALTER SCHEMA dev OWNER TO schema_admin;

------------------------------------------
-- Create User Group
------------------------------------------
GREATE GROUP data_viewers;
CREATE USER user1 PASSWORD '<password>' IN GROUP data_viewers;

------------------------------------------
-- Usage schema
------------------------------------------
GRANT USAGE ON SCHEMA dev TO GROUP data_viewers;

------------------------------------------
-- Feature grant to group
------------------------------------------
ALTER DEFAULT PRIVILEGES FOR USER root,schema_admin
IN SCHEMA dev GRANT SELECT ON TABLES TO GROUP data_viewers;
