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

#s3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  } ##lifecycle rule to prevent accidentally deletion from terraform
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#lifecycle rule (recovery)
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

# lets create a 2 groups one for admin and one for user

#admin group
resource "aws_iam_group" "admin" {
  name = "${var.bucket_name}-Admin_group"
}

#user group
resource "aws_iam_group" "user" {
  name = "${var.bucket_name}-User_group"
}

#policy for admin group - all access 
resource "aws_iam_group_policy" "admin_group_policy" {
  name  = "admin_group_policy"
  group = aws_iam_group.admin.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

# policy for users group to List objects , Get / Put objects
resource "aws_iam_group_policy" "user_group_policy" {
  name  = "user_group_policy"
  group = aws_iam_group.user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.my_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

## user membership

data "aws_iam_user" "user" {
  user_name = var.user
}

resource "aws_iam_group_membership" "membership" {
  name  = "${var.user}-group-membership"
  users = [data.aws_iam_user.user.user_name]
  group = var.environment == "admin" ? aws_iam_group.admin.name : aws_iam_group.user.name
}







