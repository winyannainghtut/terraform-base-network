# AWS Provider Configuration

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  
  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
      Project     = "base-network"
    }
  }
}