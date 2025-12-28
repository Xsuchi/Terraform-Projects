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

# security group for web deployment
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

# ec2 instance with docker bootstrap
resource "aws_instance" "web_ec2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
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
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user


docker pull xsuchii/xhub:barista-cafe-v1
docker run -d -p 80:80 xsuchii/xhub:barista-cafe-v1
EOF
}

