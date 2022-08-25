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
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Check this: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-connect.html#aws-glue-programming-etl-connect-dynamodb
dynamodb_datasource = glueContext.create_dynamic_frame.from_options(
    connection_type="dynamodb",
    connection_options={
        "dynamodb.input.tableName": args["DYNAMODB_TABLE_NAME"]
    },
    transformation_ctx="dynamodb_datasource",
)

job.commit()





class SqsBufferedBatch:
    def __init__(self, queue_url):
        self.sqs_client = boto3.client('sqs')
        self.buffer = []
        self.messages_counter = 0
        self.queue_url = queue_url

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.flush()

    def send(self, message_body):
        self.buffer.append((str(self.messages_counter), message_body))
        self.messages_counter += 1
        if (len(self.buffer) >= 10):
            self.flush()


    def flush(self):
        if len(self.buffer) == 0:
            return

        items = list(map(lambda tuple: {
            'Id': tuple[0],
            'MessageBody': tuple[1],
        }, self.buffer))

        print(items)

        self.sqs_client.send_message_batch(
            QueueUrl=self.queue_url,
            Entries=items
        )

        self.buffer.clear()





df = dynamodb_datasource.toDF()
with SqsBufferedBatch(args["SQS_URL"]) as sbb:
    for item in df.collect():
        itemAsDict = item.asDict()
        itemAsJson = json.dumps(itemAsDict)
        sbb.send(itemAsJson)
