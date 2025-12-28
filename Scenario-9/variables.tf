variable "subnet_id" {
  type        = string
  description = "value of existing subnet id where new ec2 should be launched"
}

variable "instance_ami" {
  type        = string
  description = "EC2 instance ami"
}

variable "instance_type" {
  type        = string
  description = "value of web ec2 instance type"
}

variable "volume_size" {
  type        = number
  description = "size of the volume"
  default     = 8
}

variable "instance_name" {
  type        = string
  description = "name of newly created instance"
}

/*variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the new subnet"
} */

