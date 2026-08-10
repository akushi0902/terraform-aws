variable "name" {
  description = "Base name to assign to the NAT Gateway(s) and associated resources."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "name must be between 1 and 64 characters."
  }
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create. Typically 1 for cost optimisation or one per AZ for high availability."
  type        = number
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 1
    error_message = "nat_gateway_count must be at least 1."
  }
}

variable "subnet_ids" {
  description = "List of public subnet IDs in which to place the NAT Gateways. The list length must equal nat_gateway_count."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "At least one subnet_id must be provided."
  }
}

variable "connectivity_type" {
  description = "Connectivity type for the NAT Gateway. Valid values are 'public' or 'private'."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.connectivity_type)
    error_message = "connectivity_type must be either 'public' or 'private'."
  }
}

variable "create_eip" {
  description = "Whether to create new Elastic IP addresses for the NAT Gateways. Set to false to supply existing EIP allocation IDs via eip_allocation_ids."
  type        = bool
  default     = true
}

variable "eip_allocation_ids" {
  description = "List of existing Elastic IP allocation IDs to associate with the NAT Gateways. Required when create_eip is false and connectivity_type is 'public'. Length must equal nat_gateway_count."
  type        = list(string)
  default     = []
}

variable "private_route_table_ids" {
  description = "List of private route table IDs to update with a default route pointing to the NAT Gateway(s). When multiple NAT Gateways are created, routes are distributed round-robin across them."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
