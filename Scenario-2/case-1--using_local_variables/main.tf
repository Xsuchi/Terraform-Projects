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
  #instance type 
  instance_type = (
    var.environment == "dev" ? "t2.micro" :
    var.environment == "qa" ? "t2.small" :
    var.environment == "prod" ? "t2.medium" :
    "t2.micro" # default
  )
  
  #instance ami 
  ami = var.environment == "prod" ? "ami-0ecb62995f68bb549" : "ami-068c0051b15cdb816" # Amazon Linux 2 AMI -ami-068c0051b15cdb816 , ubuntu ami - ami-0ecb62995f68bb549
  
  #instance ebs volume size
  volume_size = (
    var.environment == "dev" ? 8 :
    var.environment == "qa" ? 16 :
    var.environment == "prod" ? 32 :
    8 #default
  )
   
  #tags common to all resources
  common_tags = {
    project     = "Terraform-Project"
    Environment = "${var.environment}-server"
    author      = "Suchi"
  }
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


# SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = "${var.environment}-sg"
  description = "SG for ${var.environment} environment"
  vpc_id      = data.aws_vpc.default.id

  # Internal VPC communication only
  ingress {
    description = "Allow all internal VPC traffic"
    from_port   = 0 # all ports
    to_port     = 0 # all ports
    protocol    = "-1" # all protocols
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  # Allow all outbound
  egress {
    from_port   = 0 # all ports
    to_port     = 0 #all ports
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.environment}-sg" })
}


resource "aws_instance" "auto_ec2" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id     = data.aws_subnets.private.ids[0] # Launch in the first subnet of the VPC
  vpc_security_group_ids = [ aws_security_group.sg.id ]

  associate_public_ip_address = false  # This makes the instance private ( no public IP)

  root_block_device {
    volume_size = local.volume_size
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, { Name = "${var.environment}-server" })
}

