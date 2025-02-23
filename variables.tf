# Network Infrastructure Variables

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = false
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = false
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "The aws_region value must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The vpc_cidr value must be a valid CIDR block."
  }
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "The environment value must be one of: development, staging, production."
  }
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "base-network-vpc"
  validation {
    condition     = length(var.vpc_name) > 0 && length(var.vpc_name) <= 128
    error_message = "The vpc_name must be between 1 and 128 characters."
  }
}

variable "subnets_csv" {
  description = "Path to the CSV file containing subnet configurations"
  type        = string
  default     = "data/subnets.csv"
  validation {
    condition     = fileexists(var.subnets_csv)
    error_message = "The subnets CSV file must exist at the specified path."
  }
}

variable "nacl_rules_csv" {
  description = "Path to the CSV file containing NACL rules"
  type        = string
  default     = "data/nacl_rules.csv"
}

variable "route_tables_csv" {
  description = "Path to the CSV file containing route table configurations"
  type        = string
  default     = "data/route_tables.csv"
}

variable "security_groups_csv" {
  description = "Path to the CSV file containing security group definitions"
  type        = string
  default     = "data/security_groups.csv"
}

variable "security_group_rules_csv" {
  description = "Path to the CSV file containing security group rules"
  type        = string
  default     = "data/security_group_rules.csv"
}