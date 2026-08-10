variable "name" {
  description = "Name to assign to the Internet Gateway resource."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "The name must be between 1 and 255 characters."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to attach the Internet Gateway to during creation. Set to null to skip inline attachment and use create_attachment instead."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "vpc_id must be null or a valid VPC ID in the format vpc-xxxxxxxx."
  }
}

variable "create_attachment" {
  description = "Whether to create a separate aws_internet_gateway_attachment resource. Only used when vpc_id is null."
  type        = bool
  default     = false
}

variable "attachment_vpc_id" {
  description = "The ID of the VPC to attach via aws_internet_gateway_attachment. Required when create_attachment is true and vpc_id is null."
  type        = string
  default     = null

  validation {
    condition     = var.attachment_vpc_id == null || can(regex("^vpc-[a-f0-9]+$", var.attachment_vpc_id))
    error_message = "attachment_vpc_id must be null or a valid VPC ID in the format vpc-xxxxxxxx."
  }
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
}
