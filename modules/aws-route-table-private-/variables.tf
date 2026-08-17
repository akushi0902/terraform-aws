variable "name" {
  description = "Name of the private route table. Used as the Name tag."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "The name must be between 1 and 255 characters."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC in which the private route table will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "subnet_ids" {
  description = "List of private subnet IDs to associate with this route table."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-", id))])
    error_message = "All subnet_ids must be valid subnet IDs starting with 'subnet-'."
  }
}

variable "ipv4_routes" {
  description = "List of IPv4 route objects to add to the route table. Each object must include 'cidr_block' and at least one target key (nat_gateway_id, transit_gateway_id, vpc_peering_connection_id, vpc_endpoint_id, network_interface_id, egress_only_gateway_id, core_network_arn)."
  type        = list(map(string))
  default     = []
}

variable "ipv6_routes" {
  description = "List of IPv6 route objects to add to the route table. Each object must include 'ipv6_cidr_block' and at least one target key (nat_gateway_id, transit_gateway_id, vpc_peering_connection_id, vpc_endpoint_id, network_interface_id, egress_only_gateway_id, core_network_arn)."
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
