variable "region" {
  default = "us-east-1"
}

variable "tag_name" {}

variable "vpc_cidr_block" {}

variable "azs" {
  type = list(string)
}

variable "private_instance_ami" {
  description = "value of private instance ami"
}

variable "public_instance_ami" {
  description = "value of public instance ami"
}

variable "private_instance_type" {
  description = "value of private instance type"
}

variable "public_instance_type" {
  description = "value of public instance type"
}