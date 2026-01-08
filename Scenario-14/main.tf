terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }

  cloud {
    organization = "test_org_such"

    workspaces {
      name = "dev"
      # if you have used tag in your workspace we can use -> tags = ["web-server"] , instead of name = "dev"
    }
  }
}


provider "aws" {
  region = var.region
}

locals {
  instance_type = (
    terraform.workspace == "dev" ? "t2.micro" :
    terraform.workspace == "qa" ? "t2.small" :
    terraform.workspace == "prod" ? "t3.large" :
    "t2.micro" # default
  )

  volume_size = (
    terraform.workspace == "dev" ? 8 :
    terraform.workspace == "qa" ? 16 :
    terraform.workspace == "prod" ? 32 :
    8 #default
  )

  common_tags = {
    Project = "Terraform-Project"
    Name    = " web-server-${terraform.workspace}"
    Author  = "Suchi"
  }

}

resource "aws_instance" "auto_ec2" {
  ami           = var.ami_id
  instance_type = local.instance_type

  root_block_device {
    volume_size = local.volume_size
    volume_type = "gp3"
  }

  tags = local.common_tags
}

