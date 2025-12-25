output "instance_name" {
  value = aws_instance.new_ec2.tags["Name"]
}

output "new_instance_ip" {
  value = aws_instance.new_ec2.private_ip
}

output "new_instance_id" {
  value = aws_instance.new_ec2.id
}