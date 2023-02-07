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

# If not exist data, throw exception
df = datasource.toDF()
if df.rdd.isEmpty():
    raise Exception(
        f"Not found data in table [sample_table], partition: [yyyy=2020]"
    )

add_columns_df = (
    df.withColumnRename("yyyy", "year"
      ).withColumn("month", "03"
      ).withColumn("type",
        f.when(f.col("base_type") == "01" | f.col("base_type") == "03", f.col("num_string").cast(IntegerType())
        ).otherwise(0)
      )
)

filter_fields = [
    "id", 
    "name",
    "type", 
    "year", 
    "month"
]
remain_df = add_columns_df.select(*filter_fields)
job.commit()
