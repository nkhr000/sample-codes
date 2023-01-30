## .aws/config
[default]
region = ap-northeast-1
output = json

[profile target_switch]
source_profile = default
role_arn = arn:aws:iam::${AccountId}:role/${rolename}
mfa_serial = arn:aws:iam::${AccountId}:mfa/${username}

## .aws/credentials
[default]
aws_access_key_id = ***
aws_secret_access_key = ***