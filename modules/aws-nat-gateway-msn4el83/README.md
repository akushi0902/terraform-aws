# NAT Gateway Module

Creates one or more AWS NAT Gateways, optionally provisioning Elastic IP addresses for each.

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


### Bring your own EIPs


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name               = "my-app-prod"
  nat_gateway_count  = 1
  subnet_ids         = ["subnet-aaa"]
  connectivity_type  = "public"
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
| create_eip | Create new EIPs for the gateways | `bool` | `true` | no |
| eip_allocation_ids | Existing EIP allocation IDs (when create_eip = false) | `list(string)` | `[]` | no |
| private_route_table_ids | Private route table IDs to add default routes to | `list(string)` | `[]` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | NAT Gateway IDs |
| nat_gateway_public_ips | Public IPs of the NAT Gateways |
| nat_gateway_private_ips | Private IPs of the NAT Gateways |
| nat_gateway_subnet_ids | Subnet IDs of the NAT Gateways |
| nat_gateway_network_interface_ids | Network interface IDs |
| eip_ids | EIP allocation IDs (when create_eip = true) |
| eip_public_ips | EIP public IPs (when create_eip = true) |

## Notes

- For high availability, set `nat_gateway_count` equal to the number of Availability Zones and provide one public subnet per AZ.
- For cost optimisation in non-production environments, use a single NAT Gateway (`nat_gateway_count = 1`).
- Private NAT Gateways (`connectivity_type = "private"`) do not require an Elastic IP; `create_eip` is ignored in that case.
