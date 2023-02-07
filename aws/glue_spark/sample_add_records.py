import sys
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
import pyspark.sql.functions as f
from pyspark.sql.types import IntegerType

# get arguments
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

datasource = glueContext.create_dynamic_frame.from_catalog(
    database="sampledb",
    table_name="sample_table",
    transformation_ctx="datasource",
    push_down_predicate=f"(yyyy==2020)",
)

df = datasource.toDF()
add_column_df = df.withColumn("month", f.lit(None).cast(IntegerType()))

data_rdd = datasource.toDF().rdd
addrecord_rdd = data_rdd.flatMap(
    lambda row: (
        ( 
            row.id,
            row.name,
            row.yyyy,
            num + 1 
        )
        for num in range(0, 12)
    ),
)

result_df = spark.createDataFrame(data=addrecord_rdd, schema = add_column_df.schema)

job.commit()