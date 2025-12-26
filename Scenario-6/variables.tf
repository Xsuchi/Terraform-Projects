variable "environment" {
  description = "Environment (dev | qa | prod)"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "user_name" {
  description = "IAM username"
  type        = string
}
