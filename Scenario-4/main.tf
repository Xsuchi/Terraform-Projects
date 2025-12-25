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

# import the existing ec2 instance
data "aws_instance" "existing_ec2" {
  instance_id = var.ec2_instance_id
}

#create ami from existing instance
resource "aws_ami_from_instance" "example" {
  name               = "terraform-clone-image"
  source_instance_id = data.aws_instance.existing_ec2.id
}

# accept vpc_id from user
variable "vpc_id" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}


/*
# create a new subnet inside the selected vpc
resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "us-east-1a"
  cidr_block        = var.subnet_cidr
} */

# security group for new instance
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# neww ec2 instance created from ami of exisitng ec2
resource "aws_instance" "new_ec2" {
  ami           = aws_ami_from_instance.example.id
  instance_type = var.new_ec2_instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = var.instance_name
  }
  
user_data = <<-EOF
#!/bin/bash
# Force cloud-init to run user data in AMI clone
rm -f /var/lib/cloud/instance/boot-finished
cloud-init clean --logs

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "Hi All, welcome to website.This server is launched via terraform using AMI." > /var/www/html/index.html
EOF
}

