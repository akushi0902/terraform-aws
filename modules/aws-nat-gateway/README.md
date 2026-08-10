# NAT Gateway Module

Creates one or more AWS NAT Gateways, optionally with associated Elastic IP addresses.

## Usage


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-prod"
  nat_gateway_count  = 3
  subnet_ids         = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
  connectivity_type  = "public"
  create_eip         = true

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}


### Bring Your Own EIPs


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-prod"
  nat_gateway_count  = 1
  subnet_ids         = ["subnet-aaa"]
  create_eip         = false
  eip_allocation_ids = ["eipalloc-0123456789abcdef0"]

  tags = {
    Environment = "prod"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Base name for resources | `string` | — | yes |
| nat_gateway_count | Number of NAT Gateways to create | `number` | `1` | no |
| subnet_ids | Public subnet IDs (length must equal nat_gateway_count) | `list(string)` | — | yes |
| connectivity_type | `public` or `private` | `string` | `"public"` | no |
| create_eip | Create new EIPs | `bool` | `true` | no |
| eip_allocation_ids | Existing EIP allocation IDs (when create_eip = false) | `list(string)` | `[]` | no |
| private_route_table_ids | Route table IDs to add default routes to | `list(string)` | `[]` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | NAT Gateway IDs |
| nat_gateway_public_ips | Public IPs of NAT Gateways |
| nat_gateway_private_ips | Private IPs of NAT Gateways |
| nat_gateway_subnet_ids | Subnet IDs of NAT Gateways |
| eip_ids | EIP allocation IDs (module-created only) |
| eip_public_ips | EIP public IPs (module-created only) |
| nat_gateway_count | Number of NAT Gateways created |

## Notes

- `subnet_ids` length must equal `nat_gateway_count`.
- For high availability, set `nat_gateway_count` to the number of Availability Zones and provide one public subnet per AZ.
- Private NAT Gateways (`connectivity_type = "private"`) do not require an EIP; `create_eip` is ignored in that case.
