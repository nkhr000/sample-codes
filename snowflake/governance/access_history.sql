USE ROLE ACCOUNTADMIN;
USE WAREHOUSE WH_XSMALL;


-- 最新10件のオブジェクト変更アクセスを取得
SELECT 
    *
FROM SNOWFLAKE.ACCOUNT_USAGE.access_history
WHERE ARRAY_SIZE(OBJECTS_MODIFIED) != 0
ORDER BY query_start_time DESC
LIMIT 10
;
