output "aws_iam_user" {
  value = aws_iam_user.user.name
}

output "aws_iam_user_tags" {
  value = aws_iam_user.user.tags_all
}

output "aws_iam_user_group_membership" {
  value = aws_iam_user_group_membership.membership.groups
}

output "aws_iam_group_policy" {
  value = aws_iam_group_policy.env_policy.policy
}
