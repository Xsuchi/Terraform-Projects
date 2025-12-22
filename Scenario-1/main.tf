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

locals {
  instance_type = (
    var.environment == "dev" ? "t2.micro" :
    var.environment == "qa" ? "t2.small" :
    var.environment == "prod" ? "t3.large" :
    "t2.micro" # default
  )

  volume_size = (
    var.environment == "dev" ? 8 :
    var.environment == "qa" ? 16 :
    var.environment == "prod" ? 32 :
    8 #default
  )

  common_tags = {
    project     = "Terraform-Project"
    Environment = " web-server-${var.environment}"
    author      = "Suchi"
  }

}

resource "aws_instance" "auto_ec2" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = local.instance_type

  root_block_device {
    volume_size = local.volume_size
    volume_type = "gp3"
  }

  tags = local.common_tags
}