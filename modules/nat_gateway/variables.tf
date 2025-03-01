# NAT Gateway Module - Variables

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT Gateway will be placed"
  type        = string
}

variable "private_route_table_ids" {
  description = "List of private route table IDs to add NAT Gateway routes"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway (for dependency)"
  type        = string
}