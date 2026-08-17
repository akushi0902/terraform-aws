output "route_table_id" {
  description = "The ID of the private route table."
  value       = aws_route_table.private.id
}

output "route_table_arn" {
  description = "The ARN of the private route table."
  value       = aws_route_table.private.arn
}

output "route_table_vpc_id" {
  description = "The VPC ID associated with the private route table."
  value       = aws_route_table.private.vpc_id
}

output "route_table_owner_id" {
  description = "The ID of the AWS account that owns the private route table."
  value       = aws_route_table.private.owner_id
}

output "route_table_association_ids" {
  description = "Map of subnet ID to route table association ID."
  value       = { for k, v in aws_route_table_association.private : k => v.id }
}

output "route_table_tags" {
  description = "The tags applied to the private route table."
  value       = aws_route_table.private.tags_all
}
