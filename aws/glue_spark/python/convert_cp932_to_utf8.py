import boto3
import sys
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, [
    'INPUT_BUCKET_NAME', 
    'INPUT_FILE_PATH', 
    'INPUT_FILE_ENCODING',  # cp932
    'OUTPUT_BUCKET_NAME',
    'OUTPUT_FILE_PATH'
    ])
print('args: {0}'.format(args))

s3 = boto3.resource('s3')
input_bucket = s3.Bucket(args['INPUT_BUCKET_NAME'])

## convert sjis to utf8
for object_summary in input_bucket.objects.filter(Prefix=args['INPUT_FILE_PATH']):
    object_path = object_summary.key
    if ".csv" not in object_path:
        continue
    
    print("convert target: {0}".format(object_path))
    input_object = s3.Object(args['INPUT_BUCKET_NAME'], object_path)
    
    body = input_object.get()['Body'].read().decode(args['INPUT_FILE_ENCODING'])
    converted_path = object_path.replace(args['INPUT_FILE_PATH'], args['OUTPUT_FILE_PATH'])
    output_object = s3.Object(args['OUTPUT_BUCKET_NAME'], converted_path)
    output_object.put(Body = body)
    