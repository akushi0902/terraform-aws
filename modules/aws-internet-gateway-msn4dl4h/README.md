# terraform-aws-internet-gateway

Provisions an AWS Internet Gateway and optionally attaches it to a VPC.

## Usage

### Inline VPC attachment (most common)


module "igw" {
  source = "./modules/internet-gateway"

  name   = "my-igw"
  vpc_id = "vpc-0abc123456789def0"

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


### Separate attachment resource


module "igw" {
  source = "./modules/internet-gateway"

  name              = "my-igw"
  vpc_id            = null
  create_attachment = true
  attachment_vpc_id = "vpc-0abc123456789def0"

  tags = {
    Environment = "production"
  }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name tag for the Internet Gateway | `string` | — | yes |
| vpc_id | VPC ID for inline attachment | `string` | `null` | no |
| create_attachment | Create a separate attachment resource | `bool` | `false` | no |
| attachment_vpc_id | VPC ID for separate attachment resource | `string` | `null` | no |
| tags | Map of tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | ID of the Internet Gateway |
| internet_gateway_arn | ARN of the Internet Gateway |
| internet_gateway_owner_id | AWS account ID that owns the IGW |
| vpc_id | VPC ID the IGW is attached to |
| tags_all | All tags assigned to the IGW |

## Notes

- When `vpc_id` is provided, the gateway is attached inline during creation (recommended).
- When `vpc_id` is `null` and `create_attachment` is `true`, a separate `aws_internet_gateway_attachment` resource is created using `attachment_vpc_id`.
- Only one Internet Gateway can be attached to a VPC at a time.
