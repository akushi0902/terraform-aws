################################################################################
# General
################################################################################

variable "name" {
  description = "Name prefix for all resources created by this module."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "The name must be between 1 and 64 characters."
  }
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# Launch Template
################################################################################

variable "create_launch_template" {
  description = "Whether to create a launch template. Set to false to use an existing launch template via external_launch_template_id."
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "Description of the launch template."
  type        = string
  default     = ""
}

variable "external_launch_template_id" {
  description = "ID of an existing launch template to use when create_launch_template is false."
  type        = string
  default     = ""
}

variable "launch_template_version" {
  description = "Version of the launch template to use. Defaults to the latest version when empty."
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "ID of the AMI to use for the launch template."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type for the launch template."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair to associate with instances."
  type        = string
  default     = ""
}

variable "user_data" {
  description = "User data script to run on instance launch (plain text; will be base64-encoded)."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with instances."
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile to attach to instances."
  type        = string
  default     = ""
}

variable "ebs_optimized" {
  description = "Whether to enable EBS optimization for instances."
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed CloudWatch monitoring for instances."
  type        = bool
  default     = false
}

variable "block_device_mappings" {
  description = "List of block device mappings for the launch template."
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
    iops                  = optional(number, 0)
    throughput            = optional(number, 0)
    kms_key_id            = optional(string, "")
  }))
  default = []
}

variable "metadata_options" {
  description = "Metadata options for the launch template (IMDSv2 configuration)."
  type = object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
    instance_metadata_tags      = string
  })
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  validation {
    condition     = contains(["enabled", "disabled"], var.metadata_options.http_endpoint)
    error_message = "metadata_options.http_endpoint must be 'enabled' or 'disabled'."
  }

  validation {
    condition     = contains(["optional", "required"], var.metadata_options.http_tokens)
    error_message = "metadata_options.http_tokens must be 'optional' or 'required'."
  }
}

################################################################################
# Auto Scaling Group
################################################################################

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 0
    error_message = "min_size must be greater than or equal to 0."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 3

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be greater than or equal to 1."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number
  default     = 1

  validation {
    condition     = var.desired_capacity >= 0
    error_message = "desired_capacity must be greater than or equal to 0."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch instances in."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID must be provided."
  }
}

variable "health_check_type" {
  description = "Type of health check to perform. Valid values: EC2, ELB."
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "health_check_type must be 'EC2' or 'ELB'."
  }
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health."
  type        = number
  default     = 300

  validation {
    condition     = var.health_check_grace_period >= 0
    error_message = "health_check_grace_period must be greater than or equal to 0."
  }
}

variable "default_cooldown" {
  description = "Amount of time (in seconds) after a scaling activity completes before another can start."
  type        = number
  default     = 300

  validation {
    condition     = var.default_cooldown >= 0
    error_message = "default_cooldown must be greater than or equal to 0."
  }
}

variable "termination_policies" {
  description = "List of policies to decide how instances are terminated. Valid values: OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate, AllocationStrategy, Default."
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "List of processes to suspend for the Auto Scaling Group."
  type        = list(string)
  default     = []
}

variable "protect_from_scale_in" {
  description = "Whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in."
  type        = bool
  default     = false
}

variable "wait_for_capacity_timeout" {
  description = "Maximum duration Terraform waits for ASG instances to be healthy. Set to 0 to skip waiting."
  type        = string
  default     = "10m"
}

variable "force_delete" {
  description = "Whether to allow deleting the ASG without waiting for all instances to terminate."
  type        = bool
  default     = false
}

variable "enabled_metrics" {
  description = "List of Auto Scaling Group metrics to collect."
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "List of ALB/NLB target group ARNs to associate with the Auto Scaling Group."
  type        = list(string)
  default     = []
}

################################################################################
# Mixed Instances Policy
################################################################################

variable "use_mixed_instances_policy" {
  description = "Whether to use a mixed instances policy for the Auto Scaling Group."
  type        = bool
  default     = false
}

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by On-Demand Instances."
  type        = number
  default     = 0
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage of On-Demand Instances above the base capacity."
  type        = number
  default     = 100

  validation {
    condition     = var.on_demand_percentage_above_base_capacity >= 0 && var.on_demand_percentage_above_base_capacity <= 100
    error_message = "on_demand_percentage_above_base_capacity must be between 0 and 100."
  }
}

variable "spot_allocation_strategy" {
  description = "How to allocate capacity across Spot Instance pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized."
  type        = string
  default     = "capacity-optimized"

  validation {
    condition     = contains(["lowest-price", "capacity-optimized", "capacity-optimized-prioritized", "price-capacity-optimized"], var.spot_allocation_strategy)
    error_message = "spot_allocation_strategy must be one of: lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized."
  }
}

variable "spot_instance_pools" {
  description = "Number of Spot Instance pools to use when spot_allocation_strategy is lowest-price."
  type        = number
  default     = 2
}

variable "spot_max_price" {
  description = "Maximum price per unit hour for Spot Instances. Defaults to On-Demand price when empty."
  type        = string
  default     = ""
}

variable "mixed_instances_overrides" {
  description = "List of instance type overrides for the mixed instances policy."
  type = list(object({
    instance_type     = string
    weighted_capacity = optional(string, "")
  }))
  default = []
}

################################################################################
# Scaling Policies
################################################################################

variable "create_scaling_policies" {
  description = "Whether to create simple scale-up and scale-down Auto Scaling policies."
  type        = bool
  default     = false
}

variable "scale_up_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage. Valid values: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  type        = string
  default     = "ChangeInCapacity"

  validation {
    condition     = contains(["ChangeInCapacity", "ExactCapacity", "PercentChangeInCapacity"], var.scale_up_adjustment_type)
    error_message = "scale_up_adjustment_type must be one of: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  }
}

variable "scale_up_scaling_adjustment" {
  description = "Number of instances by which to scale up."
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "Cooldown period (in seconds) after a scale-up activity."
  type        = number
  default     = 300
}

variable "scale_down_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage. Valid values: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  type        = string
  default     = "ChangeInCapacity"

  validation {
    condition     = contains(["ChangeInCapacity", "ExactCapacity", "PercentChangeInCapacity"], var.scale_down_adjustment_type)
    error_message = "scale_down_adjustment_type must be one of: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  }
}

variable "scale_down_scaling_adjustment" {
  description = "Number of instances by which to scale down (use a negative value)."
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "Cooldown period (in seconds) after a scale-down activity."
  type        = number
  default     = 300
}

################################################################################
# Target Tracking Policy
################################################################################

variable "create_target_tracking_policy" {
  description = "Whether to create a target tracking scaling policy."
  type        = bool
  default     = false
}

variable "target_tracking_target_value" {
  description = "Target value for the target tracking scaling policy metric."
  type        = number
  default     = 50.0
}

variable "target_tracking_disable_scale_in" {
  description = "Whether to disable scale-in for the target tracking policy."
  type        = bool
  default     = false
}

variable "target_tracking_predefined_metric_type" {
  description = "Predefined metric type for target tracking. Valid values: ASGAverageCPUUtilization, ASGAverageNetworkIn, ASGAverageNetworkOut, ALBRequestCountPerTarget."
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "target_tracking_resource_label" {
  description = "Resource label for ALBRequestCountPerTarget predefined metric type."
  type        = string
  default     = ""
}

variable "target_tracking_customized_metric" {
  description = "Customized metric specification for target tracking. Set target_tracking_predefined_metric_type to empty string when using this."
  type = object({
    metric_name = string
    namespace   = string
    statistic   = string
    unit        = optional(string, "")
  })
  default = null
}

################################################################################
# Scheduled Actions
################################################################################

variable "scheduled_actions" {
  description = "Map of scheduled actions to create for the Auto Scaling Group."
  type = map(object({
    min_size         = number
    max_size         = number
    desired_capacity = number
    recurrence       = optional(string, "")
    start_time       = optional(string, "")
    end_time         = optional(string, "")
    time_zone        = optional(string, "")
  }))
  default = {}
}

################################################################################
# Lifecycle Hooks
################################################################################

variable "initial_lifecycle_hooks" {
  description = "List of initial lifecycle hooks to create with the Auto Scaling Group."
  type = list(object({
    name                    = string
    lifecycle_transition     = string
    default_result          = string
    heartbeat_timeout       = number
    notification_metadata   = optional(string, "")
    notification_target_arn = optional(string, "")
    role_arn                = optional(string, "")
  }))
  default = []
}

variable "lifecycle_hooks" {
  description = "Map of standalone lifecycle hooks to create after the Auto Scaling Group."
  type = map(object({
    lifecycle_transition     = string
    default_result          = string
    heartbeat_timeout       = number
    notification_metadata   = optional(string, "")
    notification_target_arn = optional(string, "")
    role_arn                = optional(string, "")
  }))
  default = {}
}

################################################################################
# Warm Pool
################################################################################

variable "warm_pool" {
  description = "Warm pool configuration for the Auto Scaling Group."
  type = object({
    pool_state                  = optional(string, "Stopped")
    min_size                    = optional(number, 0)
    max_group_prepared_capacity = optional(number, -1)
  })
  default = null
}
