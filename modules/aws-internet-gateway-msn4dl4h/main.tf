terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_internet_gateway_attachment" "this" {
  count = var.create_attachment && var.vpc_id == null ? 1 : 0

  internet_gateway_id = aws_internet_gateway.this.id
  vpc_id              = var.attachment_vpc_id
}
