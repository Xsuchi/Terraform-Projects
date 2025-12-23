variable "environment" {
  description = "The environment for the deployment (e.g., dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}

variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "value"
  type = number
}

variable "common_tags" {
  description = "A map of common tags to apply to all resources"
  type        = map(string)
}