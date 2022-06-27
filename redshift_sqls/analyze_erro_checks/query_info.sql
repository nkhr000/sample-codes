---------------------------
-- get running queries
---------------------------
select pid, trim(user_name), starttime, substring(query,1,20)
from stv_recents
where status='Running';

---------------------------
-- cancel query
---------------------------
CANCEL <pid>;

