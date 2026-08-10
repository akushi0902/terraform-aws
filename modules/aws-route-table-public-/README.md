# Route Table (Public) Module

Creates a public AWS Route Table with optional subnet and gateway associations, supporting both IPv4 and IPv6 routes.

## Usage


module "public_route_table" {
  source = "./modules/route-table-public"

  name   = "my-app-public-rt"
  vpc_id = "vpc-0abc123def456"

  subnet_ids  = ["subnet-0aaa111", "subnet-0bbb222"]
  gateway_ids = ["igw-0ccc333"]

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = "igw-0ccc333"
    }
  ]

  ipv6_routes = [
    {
      ipv6_cidr_block = "::/0"
      gateway_id      = "igw-0ccc333"
    }
  ]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name tag for the route table | `string` | — | yes |
| `vpc_id` | VPC ID in which to create the route table | `string` | — | yes |
| `subnet_ids` | Subnet IDs to associate with the route table | `list(string)` | `[]` | no |
| `gateway_ids` | Internet/virtual private gateway IDs for gateway-level associations | `list(string)` | `[]` | no |
| `ipv4_routes` | List of IPv4 route objects (must include `cidr_block`) | `list(map(string))` | `[]` | no |
| `ipv6_routes` | List of IPv6 route objects (must include `ipv6_cidr_block`) | `list(map(string))` | `[]` | no |
| `tags` | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `route_table_id` | ID of the public route table |
| `route_table_arn` | ARN of the public route table |
| `vpc_id` | VPC ID associated with the route table |
| `subnet_association_ids` | Map of subnet ID → association ID |
| `gateway_association_ids` | Map of gateway ID → association ID |
| `routes` | Routes defined on the route table |
| `tags` | Tags applied to the route table |

## Route Object Keys

Each entry in `ipv4_routes` supports:
- `cidr_block` (**required**)
- `gateway_id`, `nat_gateway_id`, `transit_gateway_id`, `vpc_peering_connection_id`, `network_interface_id`, `vpc_endpoint_id`, `egress_only_gateway_id`, `carrier_gateway_id`, `local_gateway_id`, `core_network_arn`

Each entry in `ipv6_routes` supports:
- `ipv6_cidr_block` (**required**)
- Same target keys as above
