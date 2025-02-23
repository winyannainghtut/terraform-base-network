# AWS Provider Configuration

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