output "instance_id" {
  value = aws_instance.ec2.id
}

output "instance_name" {
  value = aws_instance.ec2.tags["Name"]
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}
