output "bucket_arn" {
  value = aws_s3_bucket.existing_s3.arn
}
output "bucket_id" {
  value = aws_s3_bucket.existing_s3.id
}