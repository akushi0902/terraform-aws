# Route Table (Private) Module

Creates a private AWS Route Table and optionally associates it with one or more subnets.

## Usage


module "private_route_table" {
  source = "./modules/route-table-private"

  name   = "my-app-private-rt"
  vpc_id = "vpc-0abc123def456"

  subnet_ids = [
    "subnet-0abc123",
    "subnet-0def456",
  ]

  ipv4_routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = "nat-0abc123def456"
    },
    {
      cidr_block         = "10.1.0.0/16"
      transit_gateway_id = "tgw-0abc123def456"
    },
  ]

  ipv6_routes = [
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = "eigw-0abc123def456"
    },
  ]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the private route table (used as the Name tag) | `string` | — | yes |
| `vpc_id` | ID of the VPC | `string` | — | yes |
| `subnet_ids` | List of private subnet IDs to associate | `list(string)` | `[]` | no |
| `ipv4_routes` | List of IPv4 route objects | `list(map(string))` | `[]` | no |
| `ipv6_routes` | List of IPv6 route objects | `list(map(string))` | `[]` | no |
| `tags` | Map of tags to assign to all resources | `map(string)` | `{}` | no |

### Route Object Keys

**IPv4 route** (`ipv4_routes`):
- `cidr_block` *(required)*
- One of: `nat_gateway_id`, `transit_gateway_id`, `vpc_peering_connection_id`, `vpc_endpoint_id`, `network_interface_id`, `egress_only_gateway_id`, `core_network_arn`

**IPv6 route** (`ipv6_routes`):
- `ipv6_cidr_block` *(required)*
- One of: `nat_gateway_id`, `transit_gateway_id`, `vpc_peering_connection_id`, `vpc_endpoint_id`, `network_interface_id`, `egress_only_gateway_id`, `core_network_arn`

## Outputs

| Name | Description |
|------|-------------|
| `route_table_id` | ID of the private route table |
| `route_table_arn` | ARN of the private route table |
| `route_table_vpc_id` | VPC ID of the private route table |
| `route_table_owner_id` | AWS account owner ID |
| `route_table_association_ids` | Map of subnet ID to association ID |
| `route_table_tags` | All tags applied to the route table |
