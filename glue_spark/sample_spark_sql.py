import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

# Check if files existing or not in S3 path.
def exist_partition(bucket_name, prefix):
    if not prefix.endswith('/'):
        prefix = prefix + '/'

    s3 = boto3.resource('s3')
    resp = s3.meta.client.list_objects(Bucket=bucket_name, Prefix=prefix, Delimiter='/', MaxKeys=1)
    return 'Contents' in resp 

## Get Parametter
args = getResolvedOptions(sys.argv, ['JOB_NAME','yyyy', 'mm', 'bucket_name', 'partitions', 'sc_db', 'sc_table'])
print('args: {0}'.format(args))

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

## Set Paramters
year = args['yyyy']
month = args['mm']
partition_num = int(args['partition_num'])
bucket = args['bucket_name']
database = args['sc_db']
table = args['sc_table']

## Get Data By DataCatalog
datasource = glueContext.create_dynamic_frame.from_catalog(
    database = database, 
    table_name = table, 
    transformation_ctx = "datasource",
    push_down_predicate = f"(yyyy={year} and mm={month})")

## set up for spark sql
spark_sql_table = 'temp_table'
df = datasource.toDF().createOrReplaceTempView(spark_sql_table)

## execute spark sql
query = f"""
SELECT 
    id,
    name,
    yyyy,
    mm
FROM ${spark_sql_table}
WHERE key = 'extract'
"""
result = spark.sql(query)

out_df = result.repartition(partition_num)
#out_df = result.coalesce(partition_num)
dyf = DynamicFrame.fromDF(out_df, glueContext, 'out_dfy')

## Delete partitioned table before writing.
if exist_partition(bucket, f"tables/out_table/yyyy={year}/mm={month}/"):
    glueContext.purge_table(database=database, table_name=out_table, options={ 
        "partitionPredicate": f"(yyyy={year} and mm={month})", 
        "retentionPeriod": 0
    })

sink = glueContext.getSink(
    path=f"s3://{bucket}/tables/out_table/",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=["yyyy", "mm"],
    enableUpdateCatalog=True,
    transformation_ctx="sink",
)
orders_sink.setCatalogInfo(catalogDatabase=database, catalogTableName="out_table")
orders_sink.setFormat("glueparquet")
orders_sink.writeFrame(dyf)

job.commit()

