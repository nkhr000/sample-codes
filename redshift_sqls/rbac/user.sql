-- User list
select usename from pg_user;

-- Attach system role
CREATE USER secadmin_user password 'passphrase';
GRANT ROLE sys:secadmin TO secadmin_user;
CREATE USER dbadmin_user password 'passphrase';
GRANT ROLE sys:dba TO dbadmin_user;

-- RSQL Login
> HOSTNAME=<クラスタのエンドポイントURL:Port/DBNameを含まない>
> USERNAME=test_admin
> DBNAME=test
> rsql -h ${HOSTNAME} -U ${USERNAME} -d ${DBNAME}

