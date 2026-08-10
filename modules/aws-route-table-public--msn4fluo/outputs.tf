output "route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.this.id
}

output "route_table_arn" {
  description = "The ARN of the public route table."
  value       = aws_route_table.this.arn
}

output "vpc_id" {
  description = "The VPC ID associated with the public route table."
  value       = aws_route_table.this.vpc_id
}

output "subnet_association_ids" {
  description = "Map of subnet IDs to their route table association IDs."
  value       = { for k, v in aws_route_table_association.this : k => v.id }
}

output "gateway_association_ids" {
  description = "Map of gateway IDs to their route table association IDs."
  value       = { for k, v in aws_route_table_association.gateway : k => v.id }
}

output "tags" {
  description = "The tags applied to the public route table."
  value       = aws_route_table.this.tags_all
}
