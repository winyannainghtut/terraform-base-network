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

# NAT Gateway Module (for private subnet internet access)
module "nat_gateway" {
  source                  = "./modules/nat_gateway"
  vpc_name                = var.vpc_name
  environment             = var.environment
  public_subnet_id        = module.subnets.subnet_ids["public-subnet-1"]
  private_route_table_ids = [for name, id in module.route_tables.route_table_ids : id if can(regex("^private", name))]
  internet_gateway_id     = module.vpc.internet_gateway_id

  depends_on = [module.route_tables]
}

# VPC Flow Logs Module (for network traffic monitoring)
module "vpc_flow_logs" {
  source             = "./modules/vpc_flow_logs"
  vpc_id             = module.vpc.vpc_id
  vpc_name           = var.vpc_name
  environment        = var.environment
  traffic_type       = "ALL"
  log_retention_days = 30

  depends_on = [module.vpc]
}

# VPC Endpoints Module (for secure AWS service access)
module "vpc_endpoints" {
  source                      = "./modules/vpc_endpoints"
  vpc_id                      = module.vpc.vpc_id
  vpc_name                    = var.vpc_name
  vpc_cidr                    = var.vpc_cidr
  aws_region                  = var.aws_region
  environment                 = var.environment
  route_table_ids             = values(module.route_tables.route_table_ids)
  private_subnet_ids          = [for name, id in module.subnets.subnet_ids : id if can(regex("^private", name))]
  create_interface_endpoints  = true
  interface_endpoint_services = ["ec2", "ecr.api", "ecr.dkr", "ssm", "logs"]

  depends_on = [module.route_tables, module.subnets]
}