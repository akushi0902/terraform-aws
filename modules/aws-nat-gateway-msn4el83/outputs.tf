output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs."
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public IP addresses associated with the NAT Gateways."
  value       = aws_nat_gateway.this[*].public_ip
}

output "nat_gateway_private_ips" {
  description = "List of private IP addresses associated with the NAT Gateways."
  value       = aws_nat_gateway.this[*].private_ip
}

output "nat_gateway_subnet_ids" {
  description = "List of subnet IDs in which the NAT Gateways reside."
  value       = aws_nat_gateway.this[*].subnet_id
}

output "nat_gateway_network_interface_ids" {
  description = "List of network interface IDs associated with the NAT Gateways."
  value       = aws_nat_gateway.this[*].network_interface_id
}

output "eip_ids" {
  description = "List of Elastic IP allocation IDs created by this module. Empty when create_eip is false."
  value       = aws_eip.this[*].id
}

output "eip_public_ips" {
  description = "List of Elastic IP public IP addresses created by this module. Empty when create_eip is false."
  value       = aws_eip.this[*].public_ip
}
