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
  source = "./modules/vpc"

  tag_name       = var.tag_name
  vpc_cidr_block = var.vpc_cidr_block
  azs            = var.azs
}


# Public Instance
resource "aws_instance" "public_instance" {
  ami           = var.public_instance_ami
  instance_type = var.public_instance_type
  subnet_id     = module.vpc.public_subnet_ids[0]
  tags          = { Name = "public-instance" }
}

# Private Instance
resource "aws_instance" "private_instance" {
  ami           = var.private_instance_ami
  instance_type = var.private_instance_type
  subnet_id     = module.vpc.private_subnet_ids[0]
  tags          = { Name = "private-instance" }
}
