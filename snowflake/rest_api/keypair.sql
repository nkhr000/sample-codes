-- Create KeyPair (Secret Key, Public Key)
-- key should start MII (Not allowed creation by putty etc...)

-- UnEncrypted vertion (Not use for snowsql)
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Encrypted vertion (use for snowsql)
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub
-- Set Passphrase to Environment
$ set SNOWSQL_PRIVATE_KEY_PASSPHRASE=<passphrase>


-- Set Public Key to user
USE ROLE ACCOUNTADMIN;
ALTER USER <username> SET rsa_public_key='<rsa_key.p8 context>';

-- Describe
DESCRIBE USER <username>;
-- Check RSA_PUBLIC_KEY_FP (Public Key Fingerprint)

-- Unset Public Key
ALTER USER <username> UNSET rsa_public_key;

-- SELECT TEST
snowsql -a <account>.ap-northeast-1.aws -u <username> --private-key-path .ssh/rsa_key.p8
-- Ctrl+D to terminate

