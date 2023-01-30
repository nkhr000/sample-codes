#!/bin/bash

#--- 書き換えパラメータ -----
PROFILE=default
CFN_STACK_NAME=vpc
REGION=ap-northeast-1
NameTagPrefix=prd
VPCCIDR=10.1.0.0/16
#-------------------------

S3_FILEPATH=s3://${CFN_STACK_NAME}.yml

# cfn_deploy.sh deployを指定しない場合はChange-setオプションを指定
CHANGESET_OPTION="--no-execute-changeset"
if [ $# = 1 ] && [ $1 = "deploy" ]; then
    echo "deploy mode"
    CHANGESET_OPTION=""
fi

# テンプレートの実行
aws cloudformation --profile ${PROFILE} deploy --stack-name ${CFN_STACK_NAME} --template-body ${S3_FILEPATH} --region ${REGION} \
${CHANGESET_OPTION} \
--parameter-overrides \
NameTagPrefix=${NameTagPrefix} \
VPCCIDR=${VPCCIDR}
