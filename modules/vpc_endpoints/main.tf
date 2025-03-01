# VPC Endpoints Module - Main Configuration

# Create S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name        = "${var.vpc_name}-s3-endpoint"
    Environment = var.environment
  }
}

# Create DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = {
    Name        = "${var.vpc_name}-dynamodb-endpoint"
    Environment = var.environment
  }
}

# Create Interface Endpoints for other AWS services if enabled
resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = var.create_interface_endpoints ? toset(var.interface_endpoint_services) : []

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.vpc_name}-${each.value}-endpoint"
    Environment = var.environment
  }
}

# Create security group for interface endpoints if enabled
resource "aws_security_group" "endpoint_sg" {
  count = var.create_interface_endpoints ? 1 : 0

  name        = "${var.vpc_name}-endpoint-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTPS from VPC CIDR"
  }

  tags = {
    Name        = "${var.vpc_name}-endpoint-sg"
    Environment = var.environment
  }
}

# Output Endpoint IDs
output "s3_endpoint_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_endpoint_id" {
  description = "ID of the DynamoDB VPC Endpoint"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "interface_endpoint_ids" {
  description = "Map of service names to their VPC Endpoint IDs"
  value       = var.create_interface_endpoints ? { for service, endpoint in aws_vpc_endpoint.interface_endpoints : service => endpoint.id } : {}
}