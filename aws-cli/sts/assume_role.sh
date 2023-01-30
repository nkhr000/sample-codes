#/bin/sh

#--- 書き換えパラメータ -----
ROLE_ARN=arn:aws:iam::{AWS:AccountId}:role/{RoleName}
PROFILE=default
SESSIONNAME=RoleSession1
#-------------------------

aws sts assume-role --profile ${PROFILE} \
--role-arn ${ROLE_ARN} --role-session-name ${SESSIONNAME} > assume-role-output.txt