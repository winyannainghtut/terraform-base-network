# NACL Module - Main Configuration

# Read and validate NACL rules from CSV
locals {
  nacl_rules = csvdecode(file(var.nacl_rules_csv))
  
  # Validate rule numbers and create prefix mapping
  rule_prefix = {
    "public"  = { ingress = "1", egress = "3" }
    "private" = { ingress = "2", egress = "4" }
  }
  
  # Process rules with proper validation and ensure unique rule numbers
  processed_rules = {
    ingress = { for idx, rule in local.nacl_rules : "${rule.subnet_name}-${rule.rule_number}" => {
      subnet_name = rule.subnet_name
      rule_number = tonumber(rule.rule_number) + (idx * 100)
      protocol = rule.protocol
      rule_action = rule.rule_action
      cidr_block = rule.cidr_block
      from_port = rule.from_port
      to_port = rule.to_port
    } if rule.egress == "false" && can(tonumber(rule.rule_number)) }
    egress  = { for idx, rule in local.nacl_rules : "${rule.subnet_name}-${rule.rule_number}" => {
      subnet_name = rule.subnet_name
      rule_number = tonumber(rule.rule_number) + (idx * 100)
      protocol = rule.protocol
      rule_action = rule.rule_action
      cidr_block = rule.cidr_block
      from_port = rule.from_port
      to_port = rule.to_port
    } if rule.egress == "true" && can(tonumber(rule.rule_number)) }
  }
}

# Create Network ACLs
resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  subnet_ids = [for subnet_name, subnet_id in var.subnet_ids : subnet_id]

  dynamic "ingress" {
    for_each = local.processed_rules.ingress
    content {
      rule_no    = tonumber(ingress.value.rule_number)
      protocol   = ingress.value.protocol
      action     = ingress.value.rule_action
      cidr_block = ingress.value.cidr_block
      from_port  = tonumber(ingress.value.from_port)
      to_port    = tonumber(ingress.value.to_port)
    }
  }

  dynamic "egress" {
    for_each = local.processed_rules.egress
    content {
      rule_no    = tonumber(egress.value.rule_number)
      protocol   = egress.value.protocol
      action     = egress.value.rule_action
      cidr_block = egress.value.cidr_block
      from_port  = tonumber(egress.value.from_port)
      to_port    = tonumber(egress.value.to_port)
    }
  }

  tags = {
    Name        = "${var.vpc_id}-nacl"
    Environment = var.environment
  }
}

# Output NACL ID
output "nacl_id" {
  description = "ID of the created Network ACL"
  value       = aws_network_acl.this.id
}