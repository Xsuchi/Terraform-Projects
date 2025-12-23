output "instance_name" {
  value = aws_instance.auto_ec2.tags["Name"]
}

output "instance_id" {
  value = aws_instance.auto_ec2.id
}

output "instance_ebs_volume" {
  value = aws_instance.auto_ec2.root_block_device[0].volume_size
}

output "instance_sg" {
  value = aws_security_group.sg.id
}