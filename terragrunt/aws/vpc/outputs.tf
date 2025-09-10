output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.blawx_vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.blawx_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.blawx_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.blawx_vpc.private_subnet_ids
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = module.blawx_vpc.public_subnet_cidr_blocks
}

output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = module.blawx_vpc.private_subnet_cidr_blocks
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.blawx_vpc.main_route_table_id
}

output "private_route_table_ids" {
  description = "List of IDs of the private route tables"
  value       = module.blawx_vpc.private_route_table_ids
}

output "main_nacl_id" {
  description = "The ID of the main network ACL"
  value       = module.blawx_vpc.main_nacl_id
}

output "public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.blawx_vpc.public_ips
}
