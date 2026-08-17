output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway. Only set when connectivity_type is 'public'."
  value       = aws_nat_gateway.this.public_ip
}

output "nat_gateway_private_ip" {
  description = "The private IP address of the NAT Gateway."
  value       = aws_nat_gateway.this.private_ip
}

output "nat_gateway_subnet_id" {
  description = "The subnet ID in which the NAT Gateway is placed."
  value       = aws_nat_gateway.this.subnet_id
}

output "nat_gateway_allocation_id" {
  description = "The allocation ID of the Elastic IP address associated with the NAT Gateway."
  value       = aws_nat_gateway.this.allocation_id
}

output "nat_gateway_network_interface_id" {
  description = "The ENI ID of the network interface created by the NAT Gateway."
  value       = aws_nat_gateway.this.network_interface_id
}

output "eip_id" {
  description = "The ID of the Elastic IP address created by this module. Null if create_eip is false."
  value       = var.create_eip ? aws_eip.this[0].id : null
}

output "eip_public_ip" {
  description = "The public IP address of the Elastic IP created by this module. Null if create_eip is false."
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}

output "eip_allocation_id" {
  description = "The allocation ID of the Elastic IP created by this module. Null if create_eip is false."
  value       = var.create_eip ? aws_eip.this[0].id : null
}
