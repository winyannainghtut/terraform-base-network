# Main Terraform configuration file

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}


# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
  environment = var.environment
}

# Subnets Module
module "subnets" {
  source      = "./modules/subnets"
  vpc_id      = module.vpc.vpc_id
  subnets_csv = var.subnets_csv
  environment = var.environment

  depends_on = [module.vpc]
}

# Route Tables Module
module "route_tables" {
  source              = "./modules/route_tables"
  vpc_id              = module.vpc.vpc_id
  route_tables_csv    = var.route_tables_csv
  subnet_ids          = module.subnets.subnet_ids
  internet_gateway_id = module.vpc.internet_gateway_id
  environment         = var.environment

  depends_on = [module.subnets]
}

# NACL Module
module "nacls" {
  source         = "./modules/nacls"
  vpc_id         = module.vpc.vpc_id
  nacl_rules_csv = var.nacl_rules_csv
  subnet_ids     = module.subnets.subnet_ids
  environment    = var.environment

  depends_on = [module.subnets]
}

# Security Groups Module
module "security_groups" {
  source                   = "./modules/security_groups"
  vpc_id                   = module.vpc.vpc_id
  security_groups_csv      = var.security_groups_csv
  security_group_rules_csv = var.security_group_rules_csv
  environment              = var.environment

  depends_on = [module.vpc]
}