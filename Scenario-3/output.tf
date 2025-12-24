output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "bucket_policy_applied_to" {
  value = data.aws_s3_bucket.existing_bucket.id
}

output "instance_ip"{
    value = data.aws_instance.existing_ec2.private_ip
}