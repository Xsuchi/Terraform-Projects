variable "path" {
}

variable "environment" {
  description = "Environment for deployment"
  type        = string
  validation {
    condition     = contains(["dev", "qa" , "prod"], var.environment)
    error_message = "Environment must be dev or qa or prod"
  }
}