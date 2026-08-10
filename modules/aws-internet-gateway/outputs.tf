output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway."
  value       = aws_internet_gateway.this.arn
}

output "vpc_id" {
  description = "The ID of the VPC the Internet Gateway is attached to."
  value       = aws_internet_gateway.this.vpc_id
}

output "owner_id" {
  description = "The ID of the AWS account that owns the Internet Gateway."
  value       = aws_internet_gateway.this.owner_id
}
