# VPC Module - Main Configuration

# Create VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy

  tags = merge(
    {
      Name        = var.vpc_name
      Environment = var.environment
    },
    var.additional_tags
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# Output VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

# Output Internet Gateway ID
output "internet_gateway_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.this.id
}