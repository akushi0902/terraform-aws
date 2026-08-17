terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.ipv4_routes
    content {
      cidr_block                 = route.value.cidr_block
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      core_network_arn           = lookup(route.value, "core_network_arn", null)
    }
  }

  dynamic "route" {
    for_each = var.ipv6_routes
    content {
      ipv6_cidr_block            = route.value.ipv6_cidr_block
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      core_network_arn           = lookup(route.value, "core_network_arn", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = toset(var.subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}
