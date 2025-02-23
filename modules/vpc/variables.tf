# VPC Module Variables

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}