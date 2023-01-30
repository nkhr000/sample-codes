import boto3
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [JOB_NAME]

args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'INPUT_BUCKET_NAME', 
    'INPUT_FILE_PATH', 
    'OUTPUT_BUCKET_NAME',
    'OUTPUT_FILE_PATH'
    ])
print('args: {0}'.format(args))

# ジョブ初期化
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

s3 = boto3.resource('s3')
input_bucket = s3.Bucket(args['INPUT_BUCKET_NAME'])

## convert sjis to utf8
for object_summary in input_bucket.objects.filter(Prefix=args['INPUT_FILE_PATH']):
    object_path = object_summary.key
    if ".csv" not in object_path:
        continue

    input_path = "s3://{0}/{1}".format(args['INPUT_BUCKET_NAME'], object_path)
    print("compression target: {0}".format(input_path))

    dynamic_frame = glueContext.create_dynamic_frame.from_options(
        connection_type = "s3",
        connection_options = {"paths": [ input_path ]},
        format="csv",
        format_options={"separator": ",", "withHeader": False}
    )

    converted_path = object_path.replace(args['INPUT_FILE_PATH'], args['OUTPUT_FILE_PATH'])
    
    print("Compressioned path: {0}".format(converted_path))
    
    data_frame = dynamic_frame.toDF()
    print(f'The number of columns: {len(data_frame.columns)}')
    data_frame.write.mode("overwrite").format("csv"
        ).option("header", "false"
        ).option("delimiter", ","
        ).option("emptyValue", ""
        ).csv(
            "s3://{0}/{1}".format(args['OUTPUT_BUCKET_NAME'], converted_path),
            compression="gzip"
        )

job.commit()
