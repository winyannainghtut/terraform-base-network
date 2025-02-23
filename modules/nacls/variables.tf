# NACL Module Variables

variable "vpc_id" {
  description = "ID of the VPC where NACLs will be created"
  type        = string
}

variable "nacl_rules_csv" {
  description = "Path to the CSV file containing NACL rules"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet names to their IDs"
  type        = map(string)
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}