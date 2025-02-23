# Security Groups Module Variables

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "security_groups_csv" {
  description = "Path to the CSV file containing security group definitions"
  type        = string
}

variable "security_group_rules_csv" {
  description = "Path to the CSV file containing security group rules"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}