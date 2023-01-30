## ジョブ登録／実行（AWS CLI）

- S3_BUCKET=[bucketname] 
- JOB_NAME=sample_job


### put job to glue script folder

```
aws s3 cp ${JOB_NAME}.py s3://${S3_BUCKET}/glue/scripts/
```

### execute job

```
JobRunId=$(aws glue start-job-run --job-name $JOB_NAME --arguments='--[key]=[value]' --output text)
```

### check job

```
aws glue get-job-run --job-name $JOB_NAME --run-id ${JobRunId}
aws glue get-job-run --job-name $JOB_NAME --run-id ${JobRunId} | grep JobRunState
```

## get logs

```
aws logs get-log-events --log-group-name /aws-glue/jobs/output --query 'events[].[message]' --output text --log-stream-name ${JobRunId} 
```

## submit spark job

```
glue-spark-submit ${JOB_NAME}.py --JOB_NAME ${JOB_NAME} --[key] [value]
```