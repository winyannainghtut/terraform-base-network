# Subnets Module Variables

variable "vpc_id" {
  description = "ID of the VPC where subnets will be created"
  type        = string
}

variable "subnets_csv" {
  description = "Path to the CSV file containing subnet configurations"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}