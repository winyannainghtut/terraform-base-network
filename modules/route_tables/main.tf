# Route Tables Module - Main Configuration

# Read route table configurations from CSV
locals {
  route_tables = csvdecode(file(var.route_tables_csv))
}

# Create route tables
resource "aws_route_table" "this" {
  for_each = { for rt in local.route_tables : "${rt.name}-${rt.subnet_name}" => rt }

  vpc_id = var.vpc_id

  tags = {
    Name        = each.value.name
    Environment = var.environment
    Type        = can(regex("^public", each.value.name)) ? "public" : "private"
  }
}

# Add routes based on route table type
resource "aws_route" "public_internet_gateway" {
  for_each = { for name, rt in aws_route_table.this : name => rt if can(regex("^public", name)) }

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Associate route tables with subnets
resource "aws_route_table_association" "this" {
  for_each = { for rt in local.route_tables : "${rt.name}-${rt.subnet_name}" => rt }

  subnet_id      = var.subnet_ids[each.value.subnet_name]
  route_table_id = aws_route_table.this["${each.value.name}-${each.value.subnet_name}"].id
}

# Output route table IDs
output "route_table_ids" {
  description = "Map of route table names to their IDs"
  value       = { for name, rt in aws_route_table.this : name => rt.id }
}