output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway."
  value       = aws_internet_gateway.this.arn
}

output "internet_gateway_owner_id" {
  description = "The ID of the AWS account that owns the Internet Gateway."
  value       = aws_internet_gateway.this.owner_id
}

output "vpc_id" {
  description = "The ID of the VPC the Internet Gateway is attached to."
  value       = aws_internet_gateway.this.vpc_id
}

output "tags_all" {
  description = "A map of all tags assigned to the Internet Gateway, including provider-level default tags."
  value       = aws_internet_gateway.this.tags_all
}
