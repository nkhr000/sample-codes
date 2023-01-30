
--- Organization一覧の表示
USE ROLE ORGADMIN;
SHOW ORGANIZATION ACCOUNTS;

--- 共有一覧を表示
USE ROLE ACCOUNTADMIN;
SHOW SHARES;

--- 共有用のDB作成
desc share <organization-name>.<share_name>;
create database <any db name> from <organization-name>.<share_name>;

--- 共有用の利用権限付与
grant import share on account to sysadmin;

-- Create Database from share
USE SYSADMIN;



