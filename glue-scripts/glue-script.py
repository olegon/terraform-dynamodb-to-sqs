import sys
import json
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import boto3



args = getResolvedOptions(sys.argv, ["JOB_NAME", "DYNAMODB_TABLE_NAME", "SQS_URL"])
sc = SparkContext()
glueContext = GlueContext(sc)
# spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node DynamoMyDataTable
dynamodb_datasource = glueContext.create_dynamic_frame.from_options(
    connection_type="dynamodb",
    connection_options={
        "dynamodb.input.tableName": args["DYNAMODB_TABLE_NAME"]
    },
    transformation_ctx="dynamodb_datasource",
)

job.commit()

sqs_client = boto3.client('sqs')

df = dynamodb_datasource.toDF()


buffer = []

for item in df.collect():
    itemAsDict = item.asDict()
    itemAsJson = json.dumps(itemAsDict)

    print(itemAsJson)

    sqs_client.send_message(
        QueueUrl=args["DYNAMODB_TABLE_NAME"],
        MessageBody=itemAsJson
    )
