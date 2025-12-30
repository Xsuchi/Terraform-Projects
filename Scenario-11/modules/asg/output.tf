# template details

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "template_sg_inbound_rules" {
  value = aws_security_group.ec2_sg.ingress
}

output "aws_launch_template_id" {
  value = aws_launch_template.web_lt.id
}

# ASG details

output "asg_id" {
  value = aws_autoscaling_group.web_asg.id
}

output "desired_capacity" {
  value = aws_autoscaling_group.web_asg.desired_capacity
}

output "min_size" {
  value = aws_autoscaling_group.web_asg.min_size
}

output "max_size" {
  value = aws_autoscaling_group.web_asg.max_size
}



