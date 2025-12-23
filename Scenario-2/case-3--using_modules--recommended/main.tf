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
  region  = var.region
}

#fetch vpc
data "aws_vpc" "default" {
  default = true
}


# get subnets in the VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
    # this gets all subnets in the VPC
  }

  /* use this filter to get only private subnets , but i referenced default subnets . default subnets are public subnets 
 filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  } */
}


module "ec2" {
  source        = "./modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
  tags          = var.tags

  vpc_id    = data.aws_vpc.default.id
  vpc_cidr  = data.aws_vpc.default.cidr_block
  subnet_id = data.aws_subnets.private.ids[0] # Launch in the first subnet of the VPC
}
