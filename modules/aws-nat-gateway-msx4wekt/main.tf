terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_eip" "this" {
  count  = var.create_eip ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id     = var.connectivity_type == "public" ? (var.create_eip ? aws_eip.this[0].id : var.existing_eip_allocation_id) : null
  subnet_id         = var.subnet_id
  connectivity_type = var.connectivity_type

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  depends_on = [aws_eip.this]
}
