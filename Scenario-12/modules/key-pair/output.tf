output "private_key_path" {
  value       = local_file.private_key_pem.filename
  description = "Path to the private key file"
  sensitive   = true
}

output "aws_key_name" {
  value       = aws_key_pair.generated_key.key_name
  description = "AWS Key Pair name"
}
