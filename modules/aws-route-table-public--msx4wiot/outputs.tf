output "route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "route_table_arn" {
  description = "ARN of the public route table."
  value       = aws_route_table.public.arn
}

output "route_table_owner_id" {
  description = "AWS account ID that owns the public route table."
  value       = aws_route_table.public.owner_id
}

output "vpc_id" {
  description = "ID of the VPC the route table belongs to."
  value       = aws_route_table.public.vpc_id
}

output "subnet_ids" {
  description = "List of subnet IDs associated with the public route table."
  value       = [for assoc in aws_route_table_association.public : assoc.subnet_id]
}

output "route_table_association_ids" {
  description = "Map of subnet ID to route table association ID."
  value       = { for k, v in aws_route_table_association.public : k => v.id }
}
