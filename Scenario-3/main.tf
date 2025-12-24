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

# use existing ec2 instance and s3 bucket
data "aws_instance" "existing_ec2" {
  instance_id = var.ec2_instance_id
}

data "aws_s3_bucket" "existing_bucket" {
  bucket = var.s3_bucket_name
}

# create an IAM role for EC2

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
} #This role can be assumed by EC2

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_s3_access_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
} #This creates a role that EC2 instances can use

# IAM policy to allow S3 access

data "aws_iam_policy_document" "s3_access" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [data.aws_s3_bucket.existing_bucket.arn]
  }

  statement {
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["${data.aws_s3_bucket.existing_bucket.arn}/*"]
  }
}

resource "aws_iam_role_policy" "attach" {
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}


# instance profile to attach role to EC2
# instance cannot attach a role directly, it can only attach an instance profile.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_s3_access_profile"
  role = aws_iam_role.ec2_role.name
}

# Restrict S3 bucket access to only allow this EC2 role
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowOnlyEC2RoleAccess"
    effect = "Allow"
    #bucket-level permissions
    actions = [
      "s3:ListBucket"
    ]
    resources = [data.aws_s3_bucket.existing_bucket.arn]
    
     principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_role.arn]
    }
  }
  statement {
    sid    = "AllowObjectActions"
    effect = "Allow"
    
    #object-level permissions
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${data.aws_s3_bucket.existing_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_role.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "restrict" {
  bucket = data.aws_s3_bucket.existing_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}