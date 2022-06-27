set search_path to [schema_name];

-- is_integer function
create or replace function is_integer (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    try:
        if aval.isdigit():
            x = int(aval)
        else:
            return 0;
    except Exception as e:
        return 0;
    else:
        return 1;
$$ language plpythonu;

-- is_minus function
create or replace function is_minus (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    try:
        if aval.isdigit():
            x = int(aval)
        else:
            return 0;
    except Exception as e:
        return 0;
    else:
        if x < 0:
            return 1;
        return 0;
$$ language plpythonu;

-- is_double function
create or replace function is_double (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    try:
        if 'E' in aval:
            return 0;
        x = float(aval);
    except Exception as e:
        return 0;
    else:
        if x == int(x):
            return 0;
        else:
            return 1;
$$ language plpythonu;

-- is_timestamp function
create or replace function is_timestamp (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    import time
    try:
        time.strptime(aval, '%Y%m%d %H%M%S')
    except Exception as e:
        try:
            time.strptime(aval, '%Y%m%d%H%M%S')
        except Exception as e:
            return 0;
        else:
            return 1;
            
        return 0;
    else:
        return 1;
$$ language plpythonu;

create or replace function is_date (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    import time
    try:
        time.strptime(aval, '%Y%m%d')
    except Exception as e:
        return 0;
    else:
        return 1;
$$ language plpythonu;

-- is_null function
create or replace function is_null_or_empty (aval VARCHAR(MAX))
    returns integer
IMMUTABLE 
as $$
    if len(aval) == 0:
        return 1;
    return 0;
$$ language plpythonu;


CREATE OR REPLACE procedure [schema_name].collect_table_info(liketable varchar(128)) 
AS $$
DECLARE 
    rowline record;
BEGIN

EXECUTE 'set search_path to [schema_name];';
-- EXECUTE 'DROP TABLE IF EXISTS [schema_name].column_info_collection;';
EXECUTE 'CREATE TABLE IF NOT EXISTS [schema_name].column_info_collection ('
    || 'table_name VARCHAR(MAX),'
    || 'column_name VARCHAR(MAX),' 
    || 'line_count INTEGER,'
    || 'unique_number_of_items INTEGER,' 
    || 'count_integer INTEGER,'
    || 'rate_of_integer FLOAT,'
    || 'count_float INTEGER,'
    || 'rate_of_float FLOAT,'
    || 'count_minus INTEGER,'
    || 'rate_of_minus FLOAT,'
    || 'count_time_value INTEGER,'
    || 'rate_of_time_value FLOAT,'
    || 'count_date_value INTEGER,'
    || 'rate_of_date_value FLOAT,'
    || 'count_null_or_empty INTEGER,'
    || 'rate_of_null_or_empty FLOAT,'
    || 'max_len INTEGER'
    || ');'
;

FOR rowline in 
        select "tablename"::text, "column"::text from pg_table_def 
        where "schemaname" = '[schema_name]' and tablename <> 'column_info_collection' and tablename like liketable
    LOOP

    RAISE INFO 'target tablename=%, column=%', rowline.tablename, rowline.column;

    EXECUTE 'INSERT INTO [schema_name].column_info_collection('
            || 'table_name, column_name, line_count, unique_number_of_items, count_integer, rate_of_integer,' 
            || 'count_float,rate_of_float,count_minus,rate_of_minus,count_time_value,rate_of_time_value,'
            || 'count_date_value,rate_of_date_value,count_null_or_empty,' 
            || 'rate_of_null_or_empty,max_len) '
            || ' SELECT ' 
                || '''' || rowline.tablename || ''' AS table_name, ' 
                || '''' || rowline.column || ''' AS table_name, ' 
                || 'COUNT(*) AS line_count,' 
                || 'COUNT(DISTINCT ' || rowline.column || ') AS unique_number_of_items,' 
                || 'SUM(is_integer(' || rowline.column || ')) AS count_integer,' 
                || '(SUM(is_integer(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_integer,' 
                || 'SUM(is_double(' || rowline.column || ')) AS count_float,' 
                || '(SUM(is_double(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_float,' 
                || 'SUM(is_minus(' || rowline.column || ')) AS count_minus,' 
                || '(SUM(is_minus(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_minus,' 
                || 'SUM(is_timestamp(' || rowline.column || ')) AS count_time_value,' 
                || '(SUM(is_timestamp(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_time_value,' 
                || 'SUM(is_date(' || rowline.column || ')) AS count_date_value,' 
                || '(SUM(is_date(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_date_value,' 
                || 'SUM(is_null_or_empty(' || rowline.column || ')) AS count_null_or_empty,' 
                || '(SUM(is_null_or_empty(' || rowline.column || ')) + 0.0) / COUNT(*) AS rate_of_null_or_empty,' 
                || 'MAX(LEN(' || rowline.column || ')) AS max_len '
            || ' FROM ' || rowline.tablename || ';'
    ;
END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Usage
call [schema_name].collect_table_info('[tablename_prefix]_%');
SELECT * FROM [schema_name].table_info_collection LIMIT 10;