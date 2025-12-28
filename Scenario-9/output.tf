output "instance_name" {
  value = aws_instance.web_ec2.tags["Name"]
}

output "new_instance_id" {
  value = aws_instance.web_ec2.id
}

output "web_instance_private_ip" {
  value = aws_instance.web_ec2.private_ip
}

output "web_instance_public_ip" {
  value = aws_instance.web_ec2.public_ip
}
