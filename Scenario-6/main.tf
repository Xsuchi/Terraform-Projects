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

#Dev users → EC2 read-only + S3 read/write
#QA users → EC2 + S3 read-only
#Prod users → EC2 read/write

# iam group
resource "aws_iam_group" "group" {
  name = "${var.environment}-users"
  path = "/users/"
}

# create a policy 
locals {
  iam_policy = var.environment == "dev" ? {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      }
    ]
    } : var.environment == "qa" ? {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
    } : {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Describe*",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Resource = "*"
      }
    ]
  }
}

# attach policy to group
resource "aws_iam_group_policy" "env_policy" {
  name   = "${var.environment}-policy"
  group  = aws_iam_group.group.name
  policy = jsonencode(local.iam_policy)
}

# iam user
resource "aws_iam_user" "user" {
  name = var.user_name
  path = "/users/"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# add user to group 
resource "aws_iam_user_group_membership" "membership" {
  user   = aws_iam_user.user.name
  groups = [aws_iam_group.group.name]
}

