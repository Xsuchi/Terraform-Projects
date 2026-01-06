terraform {
  required_version = ">= 1.13.0" # is compatible with Terraform 1.13.0 and above

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = var.region
}


module "key_pair" {
  source      = "./modules/key-pair"
  path        = var.path
  environment = var.environment
}

module "vpc" {
  source = "./modules/vpc"

  tag_name       = var.environment
  vpc_cidr_block = var.vpc_cidr_block
  azs            = var.azs
}

module "ec2" {
  source        = "./modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = module.key_pair.aws_key_name
  tags          = var.tags

  instance_profile_name = aws_iam_instance_profile.ssm_profile.name

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnet_ids[0]
}

