# Route Tables Module Variables

variable "vpc_id" {
  description = "ID of the VPC where route tables will be created"
  type        = string
}

variable "route_tables_csv" {
  description = "Path to the CSV file containing route table configurations"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet names to their IDs"
  type        = map(string)
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway for public subnet routes"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}