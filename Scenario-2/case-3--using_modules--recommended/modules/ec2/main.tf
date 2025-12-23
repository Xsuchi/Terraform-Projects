resource "aws_security_group" "sg" {
  name        = "${var.environment}-sg"
  description = "SG for ${var.environment} environment"
  vpc_id      = var.vpc_id

  # No SSH from anywhere
  ingress {
    description = "Allow all traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr] # allow internal communication only
  }

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
  
  
  associate_public_ip_address = false  # This makes the instance private ( no public IP)
  
  tags = merge(var.tags, { Name = "${var.environment}-instance" })
}