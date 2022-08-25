module "aws_sqs_user_data" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 2.0"

  name = "user-data-queue"
}