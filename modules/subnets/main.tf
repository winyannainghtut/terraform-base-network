# Subnets Module - Main Configuration

# Read subnet configurations from CSV
locals {
  subnets = csvdecode(file(var.subnets_csv))
}

# Create subnets
resource "aws_subnet" "this" {
  for_each = { for subnet in local.subnets : subnet.name => subnet }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  # Enable auto-assign public IP for public subnets
  map_public_ip_on_launch = can(regex("^public", each.value.name)) ? true : false

  tags = {
    Name        = each.value.name
    Environment = var.environment
    Type        = can(regex("^public", each.value.name)) ? "public" : "private"
  }
}

# Output subnet IDs
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for name, subnet in aws_subnet.this : name => subnet.id }
}

# Output subnet CIDRs
output "subnet_cidrs" {
  description = "Map of subnet names to their CIDR blocks"
  value       = { for name, subnet in aws_subnet.this : name => subnet.cidr_block }
}