terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_eip" "this" {
  count  = var.create_eip ? var.nat_gateway_count : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-eip-${count.index + 1}"
    }
  )
}

locals {
  eip_allocation_ids = var.create_eip ? aws_eip.this[*].id : var.eip_allocation_ids

  # Determine subnet IDs to use — one per NAT gateway
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : []
}

resource "aws_nat_gateway" "this" {
  count = var.nat_gateway_count

  allocation_id     = var.connectivity_type == "public" ? local.eip_allocation_ids[count.index] : null
  subnet_id         = local.subnet_ids[count.index]
  connectivity_type = var.connectivity_type

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${count.index + 1}"
    }
  )

  depends_on = [aws_eip.this]
}
