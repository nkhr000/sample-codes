CREATE SCHEMA samplesc;
ALTER SCHEMA samplesc OWNER TO adminuser;

-- Setting search_path
ALTER USER adminuser SET search_path TO samplesc,public;

-- OR
SET search_path TO '$user',public, samplesc;