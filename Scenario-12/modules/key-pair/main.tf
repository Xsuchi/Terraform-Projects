# generate SSH key pair locally
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create AWS key pair from public key
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.environment}-key" 
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save Private Key Locally (Secure Permissions)
resource "local_file" "private_key_pem" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${var.path}/${var.environment}-key.pem"
  file_permission      = "0400" # Read-only for owner
  directory_permission = "0700"
}
