variable "environment" {
  description = "Environment for deployment"
  type        = string
  validation {
    condition     = contains(["user", "admin"], var.environment)
    error_message = "Environment must be user or else admin"
  }
}

variable "bucket_name" {
  description = "provide the unique bucket name"
  type        = string
}

variable "user" {
  description = "provide the user name"
  type        = string
}
