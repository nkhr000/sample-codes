
-- Role作成と継承
CREATE ROLE sa_ro;
CREATE ROLE sa_rw;
CREATE ROLE sa_admin;
CREATE ROLE developer;
CREATE ROLE analystga;
CREATE ROLE analystgb;
GRANT ROLE sa_ro TO analystga;
GRANT ROLE sa_rw TO analystgb;
GRANT ROLE sa_admin TO developer;

