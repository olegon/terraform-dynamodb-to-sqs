
locals {
  hash_key  = "pk"
  range_key = "sk"
}

module "aws_dynamodb_user_data" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name      = "user-data-table"
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
  "pk": {"S": "USER#414e7eb8-c0d5-4636-8643-7833f380bd39"},
  "sk": {"S": "#METADATA#414e7eb8-c0d5-4636-8643-7833f380bd39"},
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
  "pk": {"S": "USER#f35eb045-171b-4c4e-be68-0e4862a8a3ad"},
  "sk": {"S": "#METADATA#f35eb045-171b-4c4e-be68-0e4862a8a3ad"},
  "user_name": {"S": "Thompson"}
}
ITEM
}

resource "aws_dynamodb_table_item" "third_item" {
  table_name = module.aws_dynamodb_user_data.dynamodb_table_id
  hash_key   = local.hash_key
  range_key  = local.range_key

  item = <<ITEM
{
  "pk": {"S": "USER#dc57b7c8-76f3-4ac7-a5c6-d47ab7205f06"},
  "sk": {"S": "#METADATA#dc57b7c8-76f3-4ac7-a5c6-d47ab7205f06"},
  "user_name": {"S": "Dijkstra"}
}
ITEM
}

resource "aws_dynamodb_table_item" "fourth_item" {
  table_name = module.aws_dynamodb_user_data.dynamodb_table_id
  hash_key   = local.hash_key
  range_key  = local.range_key

  item = <<ITEM
{
  "pk": {"S": "USER#32c2d60c-cdc6-43ca-96e7-554c70ee31c5"},
  "sk": {"S": "#METADATA#32c2d60c-cdc6-43ca-96e7-554c70ee31c5"},
  "user_name": {"S": "Knuth"}
}
ITEM
}
