variable "name" {
  description = "Name to assign to the Internet Gateway resource."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "The name must be between 1 and 255 characters."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to attach the Internet Gateway to."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID in the format 'vpc-xxxxxxxxxxxxxxxxx'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Internet Gateway resource."
  type        = map(string)
  default     = {}
}
