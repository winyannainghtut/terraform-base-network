# Security Groups Module - Main Configuration

# Read security group configurations from CSV
locals {
  security_groups = csvdecode(file(var.security_groups_csv))
  security_group_rules = csvdecode(file(var.security_group_rules_csv))
}

# Create security groups
resource "aws_security_group" "this" {
  for_each = { for sg in local.security_groups : sg.name => sg }

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

# Create security group rules
resource "aws_security_group_rule" "this" {
  for_each = { for rule in local.security_group_rules : "${rule.group_name}-${rule.type}-${rule.from_port}-${rule.to_port}-${rule.protocol}" => rule }

  type              = each.value.type
  from_port         = tonumber(each.value.from_port)
  to_port           = tonumber(each.value.to_port)
  protocol          = each.value.protocol
  cidr_blocks       = try(length(each.value.cidr_blocks) > 0 ? [each.value.cidr_blocks] : null, null)
  security_group_id = aws_security_group.this[each.value.group_name].id

  source_security_group_id = try(length(each.value.source_security_groups) > 0 ? aws_security_group.this[each.value.source_security_groups].id : null, null)

  lifecycle {
    create_before_destroy = true
  }
}

# Output security group IDs
output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value       = { for name, sg in aws_security_group.this : name => sg.id }
}