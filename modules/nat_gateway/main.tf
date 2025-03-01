# NAT Gateway Module - Main Configuration

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    Environment = var.environment
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name        = "${var.vpc_name}-nat"
    Environment = var.environment
  }

  depends_on = [var.internet_gateway_id]
}

# Add route to private route tables
resource "aws_route" "private_nat_gateway" {
  count = length(var.private_route_table_ids)

  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

# Output NAT Gateway ID
output "nat_gateway_id" {
  description = "ID of the created NAT Gateway"
  value       = aws_nat_gateway.this.id
}