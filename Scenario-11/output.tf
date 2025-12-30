# Networking Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID (used for Route53 alias)"
  value       = module.alb.alb_zone_id
}

output "alb_https_endpoint" {
  description = "HTTPS endpoint of the application"
  value       = "https://${module.alb.alb_dns_name}"
}

# Auto Scaling Outputs
output "asg_id" {
  description = "Auto Scaling Group ID"
  value       = module.asg.asg_id
}

output "asg_desired_capacity" {
  description = "ASG desired capacity"
  value       = module.asg.desired_capacity
}

output "asg_min_size" {
  description = "ASG minimum size"
  value       = module.asg.min_size
}

output "asg_max_size" {
  description = "ASG maximum size"
  value       = module.asg.max_size
}

# ACM / SSL Outputs
output "acm_certificate_arn" {
  description = "ACM certificate ARN used for HTTPS"
  value       = module.acm.acm_certificate_arn
}

# DNS Output
output "application_domain" {
  description = "Public domain name of the application"
  value       = var.domain_name
}
