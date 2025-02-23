# Output values for the base network infrastructure

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = { for k, v in module.subnets.subnet_ids : k => v if can(regex("^public", k)) }
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = { for k, v in module.subnets.subnet_ids : k => v if can(regex("^private", k)) }
}

output "security_group_ids" {
  description = "IDs of the created security groups"
  value       = module.security_groups.security_group_ids
}

output "public_route_table_ids" {
  description = "IDs of the public route tables"
  value       = { for k, v in module.route_tables.route_table_ids : k => v if can(regex("^public", k)) }
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = { for k, v in module.route_tables.route_table_ids : k => v if can(regex("^private", k)) }
}