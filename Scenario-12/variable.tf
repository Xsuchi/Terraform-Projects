variable "region" {
  type = string
}

variable "path" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_cidr_block" {}

variable "azs" {
  type = list(string)
}