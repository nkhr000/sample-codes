unload ('select * from [schema].[table]')
to 's3://[bucketname]/[path-to-store-data]'
IAM_ROLE 'arn:aws:iam::[accountid]:role/[rolename]' 
parallel off
delimiter as '\t'
ALLOWOVERWRITE
;