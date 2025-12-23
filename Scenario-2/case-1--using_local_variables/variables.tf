variable "environment" {
  description = "The environment for the deployment (e.g., dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}
