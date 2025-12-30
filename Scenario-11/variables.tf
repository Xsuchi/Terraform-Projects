#region
variable "region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# tag name for resources
variable "tag_name" {
  description = "tag name for resources"
  type        = string
}

# vpc cidr block
variable "vpc_cidr_block" {
  description = "CIDR block for vpc"
  type        = string
}

# AZ's
variable "azs" {
  description = "lsit of AZ's"
  type        = list(string)
}

# EC2 ami for asg instances
variable "ami_id" {
  description = "value of ami id"
  type        = string
}

# instance type
variable "instance_type" {
  description = "value of instance type"
  type        = string
}

#ASG settings
variable "desired_capacity" {
  description = "enter the desired capacity of instance needed"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "enter the min instance needed"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "enter the max instance needed"
  type        = number
  default     = 3
}

variable "domain_name" {}

variable "hosted_zone_id" {}

