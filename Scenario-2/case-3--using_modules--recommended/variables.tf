variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
