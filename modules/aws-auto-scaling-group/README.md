# Auto Scaling Group Module

This module creates an AWS Auto Scaling Group with an optional Launch Template, scaling policies, scheduled actions, lifecycle hooks, and warm pool support.

## Features

- **Launch Template**: Creates a managed launch template or accepts an external one.
- **Mixed Instances Policy**: Supports On-Demand/Spot blended fleets with instance type overrides.
- **Scaling Policies**: Optional simple scale-up/scale-down and target tracking policies.
- **Scheduled Actions**: Map-based scheduled scaling actions.
- **Lifecycle Hooks**: Both initial (inline) and standalone lifecycle hooks.
- **Warm Pool**: Optional warm pool configuration.
- **IMDSv2**: Enforced by default via metadata options.

## Usage


module "asg" {
  source = "./modules/asg"

  name             = "my-app"
  ami_id           = "ami-0abcdef1234567890"
  instance_type    = "t3.small"
  subnet_ids       = ["subnet-aaa", "subnet-bbb"]
  security_group_ids = ["sg-12345"]

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  health_check_type = "ELB"
  target_group_arns = [module.alb.target_group_arn]

  create_target_tracking_policy          = true
  target_tracking_predefined_metric_type = "ASGAverageCPUUtilization"
  target_tracking_target_value           = 60.0

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}


## Mixed Instances (Spot + On-Demand)


module "asg" {
  source = "./modules/asg"

  name                   = "my-app-mixed"
  ami_id                 = "ami-0abcdef1234567890"
  instance_type          = "t3.medium"
  subnet_ids             = ["subnet-aaa", "subnet-bbb"]
  use_mixed_instances_policy = true

  on_demand_base_capacity                  = 1
  on_demand_percentage_above_base_capacity = 25
  spot_allocation_strategy                 = "capacity-optimized"

  mixed_instances_overrides = [
    { instance_type = "t3.medium" },
    { instance_type = "t3.large" },
    { instance_type = "t3a.medium" },
  ]

  min_size         = 2
  max_size         = 10
  desired_capacity = 4
  tags             = { Environment = "staging" }
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name prefix for all resources | `string` | — | yes |
| `tags` | Map of tags to assign to resources | `map(string)` | `{}` | no |
| `subnet_ids` | Subnet IDs for the ASG | `list(string)` | — | yes |
| `ami_id` | AMI ID for the launch template | `string` | `""` | no |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `min_size` | Minimum ASG size | `number` | `1` | no |
| `max_size` | Maximum ASG size | `number` | `3` | no |
| `desired_capacity` | Desired ASG capacity | `number` | `1` | no |
| `health_check_type` | EC2 or ELB | `string` | `"EC2"` | no |
| `target_group_arns` | ALB/NLB target group ARNs | `list(string)` | `[]` | no |
| `create_launch_template` | Create a launch template | `bool` | `true` | no |
| `use_mixed_instances_policy` | Enable mixed instances policy | `bool` | `false` | no |
| `create_scaling_policies` | Create simple scaling policies | `bool` | `false` | no |
| `create_target_tracking_policy` | Create target tracking policy | `bool` | `false` | no |
| `scheduled_actions` | Map of scheduled actions | `map(object)` | `{}` | no |
| `lifecycle_hooks` | Map of lifecycle hooks | `map(object)` | `{}` | no |
| `warm_pool` | Warm pool configuration | `object` | `null` | no |

See `variables.tf` for the full list of inputs and their descriptions.

## Outputs

| Name | Description |
|------|-------------|
| `autoscaling_group_id` | ID of the Auto Scaling Group |
| `autoscaling_group_arn` | ARN of the Auto Scaling Group |
| `autoscaling_group_name` | Name of the Auto Scaling Group |
| `launch_template_id` | ID of the launch template |
| `launch_template_arn` | ARN of the launch template |
| `scale_up_policy_arn` | ARN of the scale-up policy |
| `scale_down_policy_arn` | ARN of the scale-down policy |
| `target_tracking_policy_arn` | ARN of the target tracking policy |
