resource "aws_security_group" "sg" {
  name        = "${var.environment}-sg"
  description = "SG for ${var.environment} environment"
  vpc_id      = var.vpc_id

  # No inbound rules needed when using SSM
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.environment}-sg" })
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = var.key_name
  iam_instance_profile = var.instance_profile_name
  
  associate_public_ip_address = false  # This makes the instance private ( no public IP)
  
  tags = merge(var.tags, { Name = "${var.environment}-instance" })
}

