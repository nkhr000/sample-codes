set query_group to 'qlabel1';
SET
-- クエリの実行
select * from category limit 1;


-- 実行したクエリIDをラベルで絞る
-- svl_qlogはDB上で実行されたクエリの全記録
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVL_QLOG.html
select 
    userid AS user_id,
    query AS query_id, 
    xid AS transaction_id,
    pid AS process_id, 
    substring AS query_text, 
    elapsed AS query_executed_time, 
    label AS query_group
from svl_qlog 
where label ='qlabel1'
order by query;