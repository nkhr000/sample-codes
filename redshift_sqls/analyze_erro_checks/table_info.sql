set search_path to [schemaname];
SELECT
  *
FROM
    PG_TABLE_DEF
WHERE
    schemaname = '[schemaname]';