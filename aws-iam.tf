resource "aws_iam_role" "glue_role" {
  name = "glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "glue"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "terraform-inline-policy"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:AssociateKmsKey"
    ]
    resources = [
      "arn:aws:logs:*:*:/aws-glue/*"
    ]
  }

  statement {
    actions = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = [
      module.aws_s3_bucket_glue_scripts.s3_bucket_arn,
      "${module.aws_s3_bucket_glue_scripts.s3_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [
      module.aws_dynamodb_user_data.dynamodb_table_arn
    ]
  }

  statement {
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      module.aws_sqs_user_data.this_sqs_queue_arn
    ]
  }
}
