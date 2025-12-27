terraform {
  required_version = ">= 1.13.0" # is compatible with Terraform 1.13.0 and above

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# fetch the user whom you want to restrict access
data "aws_iam_user" "user" {
  user_name = var.user_name
}

# fetch the bucket name to which the access should be restricted
data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

# create a iam policy to List objects , Get / Put objects
resource "aws_iam_user_policy" "restrict_s3_bucket" {
  name = "restrict-to-single-bucket"
  user = data.aws_iam_user.user.user_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = data.aws_s3_bucket.bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${data.aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}
