# NAT Gateway Module

Provisions an AWS NAT Gateway with an optional Elastic IP address. Supports both public and private connectivity types.

## Usage

### Public NAT Gateway (new EIP)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = "my-nat-gateway"
  subnet_id         = "subnet-0abc123def456789"
  connectivity_type = "public"
  create_eip        = true

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


### Public NAT Gateway (existing EIP)


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name                       = "my-nat-gateway"
  subnet_id                  = "subnet-0abc123def456789"
  connectivity_type          = "public"
  create_eip                 = false
  existing_eip_allocation_id = "eipalloc-0abc123def456789"

  tags = {
    Environment = "production"
  }
}


### Private NAT Gateway


module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = "my-private-nat"
  subnet_id         = "subnet-0abc123def456789"
  connectivity_type = "private"
  create_eip        = false

  tags = {
    Environment = "production"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name for the NAT Gateway and associated resources | `string` | — | yes |
| subnet_id | Subnet ID in which to place the NAT Gateway | `string` | — | yes |
| connectivity_type | Connectivity type: `public` or `private` | `string` | `"public"` | no |
| create_eip | Whether to create a new EIP (public only) | `bool` | `true` | no |
| existing_eip_allocation_id | Existing EIP allocation ID (public, create_eip=false) | `string` | `null` | no |
| tags | Map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_id | NAT Gateway ID |
| nat_gateway_public_ip | Public IP of the NAT Gateway |
| nat_gateway_private_ip | Private IP of the NAT Gateway |
| nat_gateway_subnet_id | Subnet ID of the NAT Gateway |
| nat_gateway_allocation_id | EIP allocation ID associated with the NAT Gateway |
| nat_gateway_network_interface_id | ENI ID of the NAT Gateway |
| eip_id | ID of the EIP created by this module |
| eip_public_ip | Public IP of the EIP created by this module |
| eip_allocation_id | Allocation ID of the EIP created by this module |

## Notes

- When `connectivity_type` is `private`, no EIP is required and `create_eip` should be `false`.
- The subnet provided for a public NAT Gateway must be a public subnet (with an Internet Gateway route).
- Use the `nat_gateway_id` output to create route table entries pointing `0.0.0.0/0` to this NAT Gateway for private subnets.
