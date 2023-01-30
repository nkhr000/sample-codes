--------------------------------
-- display error raw line
--------------------------------
SELECT
    TRIM(starttime) AS starttime,
    TRIM(filename) AS filename,
    TRIM(line_number) AS line_number,
    TRIM(raw_line) AS raw_line
FROM
    stl_load_errors
ORDER BY
    starttime DESC
LIMIT 1;

--------------------------------
-- display error reason column
--------------------------------
SELECT
    TRIM(starttime) AS starttime,
    TRIM(colname) AS colname,
    TRIM(type) AS type,
    TRIM(col_length) AS col_length,
    TRIM(position) AS position,
    TRIM(raw_field_value) AS raw_field_value,
    TRIM(err_code) AS err_code,
    TRIM(err_reason) AS err_reason
FROM
    stl_load_errors
ORDER BY
    starttime DESC
LIMIT 1;

--------------------------------
-- load error by table
--------------------------------
select c.relname table_name, s.* 
from stl_load_errors s, pg_class c 
where c.oid = s.tbl and c.relname = '<your table name>'


--------------------------------
-- detail information
--------------------------------
SELECT
    stl_loaderror_detail.userid,
    stl_loaderror_detail.slice,
    stl_loaderror_detail.session,
    TRIM(stl_loaderror_detail.query) AS query,
    TRIM(stl_loaderror_detail.filename) AS filename,
    stl_loaderror_detail.line_number,
    TRIM(stl_loaderror_detail.field) AS field,
    TRIM(stl_loaderror_detail.colname) AS colname,
    TRIM(stl_loaderror_detail.value) AS value,
    stl_loaderror_detail.is_null,
    stl_loaderror_detail.type,
    stl_loaderror_detail.col_length
FROM
    stl_loaderror_detail  
--WHERE
--  session = <セッションID>
--  AND query = <クエリID>;