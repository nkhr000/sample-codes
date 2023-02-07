#/bin/sh

set -e -u pipefail

#--- 書き換えパラメータ -----
PROFILE=default
REGION=ap-northeast-1
STACKNAME=vpc
#-------------------------

delete_stack () {
    echo "Delete stack"
    aws cloudformation delete-stack --stack-name $STACKNAME --region $REGION --profile $PROFILE
    aws cloudformation wait stack-delete-complete --stack-name $STACKNAME --region $REGION --profile $PROFILE
}

time delete_stack