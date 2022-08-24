resource "aws_glue_job" "from_dynamo_to_sqs_job" {
  name     = "from-dynamodb-to-sqs-poc"
  role_arn = aws_iam_role.glue_role.arn
  glue_version = "3.0"

  command {
    script_location = "s3://${module.aws_s3_bucket_glue_scripts.s3_bucket_id}/${aws_s3_bucket_object.from_dynamo_to_sqs_glue_script.id}"
  }

  default_arguments = {
    "--DYNAMODB_TABLE_NAME" = module.aws_dynamodb_user_data.dynamodb_table_id
    "--SQS_URL" = module.aws_sqs_user_data.this_sqs_queue_id
  }
}
