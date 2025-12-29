variable "vpc_cidr_block" {
    description = "provide the cidr block for the vpc"
    type    = string
    default = "10.0.0.0/16"
}

variable "tag_name" {
  type = string
  description = "Name tag for the VPC"
}

variable "azs" { 
    type = list(string)
    default = ["us-east-1a", "us-east-1b"] 
    description = "provide the list of availability zones"
}
