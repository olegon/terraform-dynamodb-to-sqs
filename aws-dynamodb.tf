
locals {
  hash_key  = "pk"
  range_key = "sk"
}

module "aws_dynamodb_user_data" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name      = "glue-poc-user-data"
  hash_key  = local.hash_key
  range_key = local.range_key


  attributes = [
    {
      name = local.hash_key
      type = "S"
    },
    {
      name = local.range_key
      type = "S"
    }
  ]
}

resource "aws_dynamodb_table_item" "first_item" {
  table_name = module.aws_dynamodb_user_data.dynamodb_table_id
  hash_key   = local.hash_key
  range_key  = local.range_key

  item = <<ITEM
{
  "pk": {"S": "USER#123"},
  "sk": {"S": "#METADATA#123"},
  "user_name": {"S": "Ritchie"}
}
ITEM
}

resource "aws_dynamodb_table_item" "second_item" {
  table_name = module.aws_dynamodb_user_data.dynamodb_table_id
  hash_key   = local.hash_key
  range_key  = local.range_key

  item = <<ITEM
{
  "pk": {"S": "USER#123"},
  "sk": {"S": "LANGUAGE#C"},
  "observation": {"S": "I've created it!"}
}
ITEM
}
