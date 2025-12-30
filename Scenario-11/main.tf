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
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  tag_name       = var.tag_name
  vpc_cidr_block = var.vpc_cidr_block
  azs            = var.azs
}

module "acm" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}

module "alb" {
  source            = "./modules/alb"
  tag_name          = var.tag_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = module.acm.acm_certificate_arn
}

module "asg" {
  source             = "./modules/asg"
  tag_name           = var.tag_name
  vpc_id             = module.vpc.vpc_id
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  private_subnet_ids = module.vpc.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  ec2_sg_id          = module.alb.alb_sg_id

  instance_profile_name = aws_iam_instance_profile.ssm_profile.name
}

module "route53" {
  source         = "./modules/route53"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}
