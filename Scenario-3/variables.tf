variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ec2_instance_id" {
  description = "Existing EC2 instance ID"
  type        = string
}

variable "s3_bucket_name" {
  description = "Existing S3 bucket name"
  type        = string
}
