variable "tag_name" {
  
}

variable "vpc_id" {
}

variable "ami_id" {
  description = "value of ami id"
  type = string
}

variable "instance_type" {
  description = "value of instance type"
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  
}

variable "ec2_sg_id" {
  description = "value of sg id"
  type = string
}

variable "desired_capacity" {
    description = "enter the desired capacity of instance needed"
  type = number
  default = 2
}

variable "min_size" {
  description = "enter the min instance needed"
  type = number
  default = 1
}

variable "max_size" {
  description = "enter the max instance needed"
  type = number
  default = 3
}

variable "instance_profile_name" {
  type = string
}