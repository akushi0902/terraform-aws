# Route Table (Public) Module

Creates a public AWS Route Table with optional Internet Gateway default routes and subnet associations.

## Usage


module "public_route_table" {
  source = "./modules/route-table-public"

  name                      = "my-app-public-rt"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.public_subnet_ids
  internet_gateway_id       = module.vpc.internet_gateway_id
  enable_ipv6_internet_route = true

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name tag for the route table | `string` | — | yes |
| `vpc_id` | VPC ID | `string` | — | yes |
| `subnet_ids` | Subnet IDs to associate | `list(string)` | `[]` | no |
| `internet_gateway_id` | IGW ID for default 0.0.0.0/0 route | `string` | `null` | no |
| `enable_ipv6_internet_route` | Add ::/0 route via IGW | `bool` | `false` | no |
| `ipv4_routes` | Additional inline IPv4 routes | `list(map(string))` | `[]` | no |
| `ipv6_routes` | Additional inline IPv6 routes | `list(map(string))` | `[]` | no |
| `tags` | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `route_table_id` | Route table ID |
| `route_table_arn` | Route table ARN |
| `route_table_owner_id` | Owning AWS account ID |
| `vpc_id` | VPC ID |
| `subnet_ids` | Associated subnet IDs |
| `route_table_association_ids` | Map of subnet ID → association ID |
