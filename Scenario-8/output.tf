output "user_name" {
  description = "IAM user name"
  value       = var.user
}

output "user_belongs_to_group" {
  description = "IAM group the user is assigned to"
  value       = aws_iam_group_membership.membership.group
}

output "bucket_arn" {
  description = "protected S3 bucket ARN"
  value       = aws_s3_bucket.my_bucket.arn
}

output "admin_group_name" {
  description = "admin IAM group name"
  value       = aws_iam_group.admin.name
}

output "user_group_name" {
  description = "user IAM group name"
  value       = aws_iam_group.user.name
}
