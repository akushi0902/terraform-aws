# Internet Gateway Module

Creates and attaches an AWS Internet Gateway to an existing VPC.

## Usage


module "igw" {
  source = "./modules/internet-gateway"

  name   = "my-igw"
  vpc_id = "vpc-0abc123def456789a"

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name to assign to the Internet Gateway resource. | `string` | n/a | yes |
| vpc_id | The ID of the VPC to attach the Internet Gateway to. | `string` | n/a | yes |
| tags | A map of tags to assign to the Internet Gateway resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | The ID of the Internet Gateway. |
| internet_gateway_arn | The ARN of the Internet Gateway. |
| vpc_id | The ID of the VPC the Internet Gateway is attached to. |
| owner_id | The ID of the AWS account that owns the Internet Gateway. |
