# VPC Endpoints Module - Variables

variable "vpc_id" {
  description = "ID of the VPC to create endpoints in"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used for naming resources)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (used for security group rules)"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with gateway endpoints"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate with interface endpoints"
  type        = list(string)
  default     = []
}

variable "create_interface_endpoints" {
  description = "Whether to create interface endpoints for AWS services"
  type        = bool
  default     = false
}

variable "interface_endpoint_services" {
  description = "List of AWS service names to create interface endpoints for (e.g., ec2, ecr.api)"
  type        = list(string)
  default     = ["ec2", "ecr.api", "ecr.dkr", "ssm", "logs"]
}