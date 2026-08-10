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
