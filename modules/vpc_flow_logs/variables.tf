# VPC Flow Logs Module - Variables

variable "vpc_id" {
  description = "ID of the VPC to enable flow logs for"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used for naming resources)"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "traffic_type" {
  description = "Type of traffic to log (ACCEPT, REJECT, or ALL)"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.traffic_type)
    error_message = "The traffic_type value must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "log_retention_days" {
  description = "Number of days to retain flow logs in CloudWatch"
  type        = number
  default     = 30
  validation {
    condition     = var.log_retention_days > 0
    error_message = "The log_retention_days value must be greater than 0."
  }
}