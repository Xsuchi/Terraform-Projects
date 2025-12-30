# template sg
resource "aws_security_group" "ec2_sg" {
  name        = "${var.tag_name}-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#launch template for sg
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user

    docker pull xsuchii/xhub:barista-cafe-v1
    docker run -d -p 80:80 xsuchii/xhub:barista-cafe-v1
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-web-instance"
    }
  }
}

# autoscaling group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag { 
    key                 = "InstanceType"
    value               = var.tag_name
    propagate_at_launch = true
  }
}
