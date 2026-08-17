variable "name" {
  description = "Name to assign to the public route table (used as the Name tag)."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "The name must not be empty."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which to create the public route table."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "subnet_ids" {
  description = "List of public subnet IDs to associate with the route table."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-", id))])
    error_message = "All subnet_ids must be valid subnet IDs starting with 'subnet-'."
  }
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway to use for the default IPv4 (0.0.0.0/0) route. Set to null to skip creating the default route."
  type        = string
  default     = null

  validation {
    condition     = var.internet_gateway_id == null || can(regex("^igw-", var.internet_gateway_id))
    error_message = "The internet_gateway_id must be null or a valid Internet Gateway ID starting with 'igw-'."
  }
}

variable "enable_ipv6_internet_route" {
  description = "When true and internet_gateway_id is set, also create a default IPv6 (::/0) route via the Internet Gateway."
  type        = bool
  default     = false
}

variable "ipv4_routes" {
  description = "List of additional IPv4 route objects to add inline to the route table. Each object must include cidr_block and at least one target key (gateway_id, nat_gateway_id, transit_gateway_id, vpc_peering_connection_id, network_interface_id, vpc_endpoint_id, egress_only_gateway_id, carrier_gateway_id, local_gateway_id, or core_network_arn)."
  type        = list(map(string))
  default     = []
}

variable "ipv6_routes" {
  description = "List of additional IPv6 route objects to add inline to the route table. Each object must include ipv6_cidr_block and at least one target key."
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}
