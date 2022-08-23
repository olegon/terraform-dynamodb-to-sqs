module "aws_s3_bucket_glue_scripts" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "olegon-glue-scripts"

  versioning = {
    enabled = true
  }

  force_destroy = true
}

resource "aws_s3_bucket_object" "glue_script" {
  bucket = module.aws_s3_bucket_glue_scripts.s3_bucket_id
  key    = "glue-script.py"
  source = "./glue-scripts/glue-script.py"
  etag = filemd5("./glue-scripts/glue-script.py")
}
