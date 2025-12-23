output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_name" {
  description = "The Name tag of the EC2 instance"
  value       = module.ec2.instance_name
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.ec2.security_group_id
}