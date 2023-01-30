USE ROLE ACCOUNTADMIN;
USE WH_XSMALL;

--- 指定したBundle名の変更が有効か無効かを取得
--- https://docs.snowflake.com/en/sql-reference/functions/system_behavior_change_bundle_status.html
SELECT SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2021_10');

--- 有効化
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2021_10');
