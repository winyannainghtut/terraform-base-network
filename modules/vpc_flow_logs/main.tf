# VPC Flow Logs Module - Main Configuration

# Create CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc-flow-logs/${var.vpc_id}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.vpc_name}-flow-logs"
    Environment = var.environment
  }
}

# Create IAM Role for VPC Flow Logs
resource "aws_iam_role" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.vpc_name}-flow-logs-role"
    Environment = var.environment
  }
}

# Create IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Create VPC Flow Logs
resource "aws_flow_log" "this" {
  log_destination      = aws_cloudwatch_log_group.flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = var.traffic_type
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.flow_logs.arn

  tags = {
    Name        = "${var.vpc_name}-flow-logs"
    Environment = var.environment
  }
}

# Output Flow Log ID
output "flow_log_id" {
  description = "ID of the created VPC Flow Log"
  value       = aws_flow_log.this.id
}

# Output CloudWatch Log Group ARN
output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.flow_logs.arn
}