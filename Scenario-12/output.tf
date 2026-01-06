output "aws_key_name" {
  value = module.key_pair.aws_key_name
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}
