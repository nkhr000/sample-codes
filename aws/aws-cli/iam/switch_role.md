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


### AWS CLI SwitchRole Command

- Swtich Roleの実行

```
SWITCH_CMD=$(aws sts assume-role --role-arn 'arn:aws:iam::<AWS-ACCOUNT-ID>:role/vein-bastion' \
--role-session-name 'switch-to-own-bastion' \
--query 'Credentials.join(``,[`export AWS_ACCESS_KEY_ID=\"`,AccessKeyId,`\" AWS_SECRET_ACCESS_KEY=\"`,SecretAccessKey,`\" AWS_SESSION_TOKEN=\"`,SessionToken,`\"`])' \
--output text) \
&& eval ${SWITCH_CMD} \
&& aws sts get-caller-identity
```

- Switch Roleの解除

```
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```