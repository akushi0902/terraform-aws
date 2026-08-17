terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  name = var.name
  tags = merge(var.tags, {
    Name = var.name
  })
}

################################################################################
# Launch Template
################################################################################

resource "aws_launch_template" "this" {
  count = var.create_launch_template ? 1 : 0

  name        = "${local.name}-lt"
  description = var.launch_template_description

  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name != "" ? var.key_name : null
  user_data              = var.user_data != "" ? base64encode(var.user_data) : null
  vpc_security_group_ids = var.security_group_ids

  ebs_optimized = var.ebs_optimized

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_arn != "" ? [1] : []
    content {
      arn = var.iam_instance_profile_arn
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        encrypted             = block_device_mappings.value.encrypted
        delete_on_termination = block_device_mappings.value.delete_on_termination
        iops                  = block_device_mappings.value.volume_type == "io1" || block_device_mappings.value.volume_type == "io2" || block_device_mappings.value.volume_type == "gp3" ? block_device_mappings.value.iops : null
        throughput            = block_device_mappings.value.volume_type == "gp3" ? block_device_mappings.value.throughput : null
        kms_key_id            = block_device_mappings.value.kms_key_id != "" ? block_device_mappings.value.kms_key_id : null
      }
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }

  dynamic "monitoring" {
    for_each = var.enable_detailed_monitoring ? [1] : []
    content {
      enabled = true
    }
  }

  dynamic "tag_specifications" {
    for_each = ["instance", "volume"]
    content {
      resource_type = tag_specifications.value
      tags          = local.tags
    }
  }

  tags = local.tags
}

################################################################################
# Auto Scaling Group
################################################################################

resource "aws_autoscaling_group" "this" {
  name                      = local.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  protect_from_scale_in     = var.protect_from_scale_in
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  force_delete              = var.force_delete
  enabled_metrics           = var.enabled_metrics
  target_group_arns         = var.target_group_arns

  dynamic "launch_template" {
    for_each = var.create_launch_template ? [1] : []
    content {
      id      = aws_launch_template.this[0].id
      version = var.launch_template_version == "" ? aws_launch_template.this[0].latest_version : var.launch_template_version
    }
  }

  dynamic "launch_template" {
    for_each = !var.create_launch_template && var.external_launch_template_id != "" ? [1] : []
    content {
      id      = var.external_launch_template_id
      version = var.launch_template_version == "" ? "$Latest" : var.launch_template_version
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_mixed_instances_policy ? [1] : []
    content {
      instances_distribution {
        on_demand_base_capacity                  = var.on_demand_base_capacity
        on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
        spot_allocation_strategy                 = var.spot_allocation_strategy
        spot_instance_pools                      = var.spot_allocation_strategy == "lowest-price" ? var.spot_instance_pools : null
        spot_max_price                           = var.spot_max_price != "" ? var.spot_max_price : null
      }

      launch_template {
        launch_template_specification {
          launch_template_id = var.create_launch_template ? aws_launch_template.this[0].id : var.external_launch_template_id
          version            = var.launch_template_version == "" ? (var.create_launch_template ? aws_launch_template.this[0].latest_version : "$Latest") : var.launch_template_version
        }

        dynamic "override" {
          for_each = var.mixed_instances_overrides
          content {
            instance_type     = override.value.instance_type
            weighted_capacity = override.value.weighted_capacity != "" ? override.value.weighted_capacity : null
          }
        }
      }
    }
  }

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hooks
    content {
      name                 = initial_lifecycle_hook.value.name
      lifecycle_transition = initial_lifecycle_hook.value.lifecycle_transition
      default_result       = initial_lifecycle_hook.value.default_result
      heartbeat_timeout    = initial_lifecycle_hook.value.heartbeat_timeout
      notification_metadata = initial_lifecycle_hook.value.notification_metadata != "" ? initial_lifecycle_hook.value.notification_metadata : null
      notification_target_arn = initial_lifecycle_hook.value.notification_target_arn != "" ? initial_lifecycle_hook.value.notification_target_arn : null
      role_arn             = initial_lifecycle_hook.value.role_arn != "" ? initial_lifecycle_hook.value.role_arn : null
    }
  }

  dynamic "warm_pool" {
    for_each = var.warm_pool != null ? [var.warm_pool] : []
    content {
      pool_state                  = warm_pool.value.pool_state
      min_size                    = warm_pool.value.min_size
      max_group_prepared_capacity = warm_pool.value.max_group_prepared_capacity
    }
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

################################################################################
# Auto Scaling Policies
################################################################################

resource "aws_autoscaling_policy" "scale_up" {
  count = var.create_scaling_policies ? 1 : 0

  name                   = "${local.name}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = var.scale_up_adjustment_type
  scaling_adjustment     = var.scale_up_scaling_adjustment
  cooldown               = var.scale_up_cooldown
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
  count = var.create_scaling_policies ? 1 : 0

  name                   = "${local.name}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = var.scale_down_adjustment_type
  scaling_adjustment     = var.scale_down_scaling_adjustment
  cooldown               = var.scale_down_cooldown
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "target_tracking" {
  count = var.create_target_tracking_policy ? 1 : 0

  name                   = "${local.name}-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value     = var.target_tracking_target_value
    disable_scale_in = var.target_tracking_disable_scale_in

    dynamic "predefined_metric_specification" {
      for_each = var.target_tracking_predefined_metric_type != "" ? [1] : []
      content {
        predefined_metric_type = var.target_tracking_predefined_metric_type
        resource_label         = var.target_tracking_resource_label != "" ? var.target_tracking_resource_label : null
      }
    }

    dynamic "customized_metric_specification" {
      for_each = var.target_tracking_customized_metric != null ? [var.target_tracking_customized_metric] : []
      content {
        metric_name = customized_metric_specification.value.metric_name
        namespace   = customized_metric_specification.value.namespace
        statistic   = customized_metric_specification.value.statistic
        unit        = customized_metric_specification.value.unit != "" ? customized_metric_specification.value.unit : null
      }
    }
  }
}

################################################################################
# Scheduled Actions
################################################################################

resource "aws_autoscaling_schedule" "this" {
  for_each = var.scheduled_actions

  scheduled_action_name  = each.key
  autoscaling_group_name = aws_autoscaling_group.this.name
  min_size               = each.value.min_size
  max_size               = each.value.max_size
  desired_capacity       = each.value.desired_capacity
  recurrence             = each.value.recurrence != "" ? each.value.recurrence : null
  start_time             = each.value.start_time != "" ? each.value.start_time : null
  end_time               = each.value.end_time != "" ? each.value.end_time : null
  time_zone              = each.value.time_zone != "" ? each.value.time_zone : null
}

################################################################################
# Lifecycle Hooks (standalone)
################################################################################

resource "aws_autoscaling_lifecycle_hook" "this" {
  for_each = var.lifecycle_hooks

  name                   = each.key
  autoscaling_group_name = aws_autoscaling_group.this.name
  lifecycle_transition   = each.value.lifecycle_transition
  default_result         = each.value.default_result
  heartbeat_timeout      = each.value.heartbeat_timeout
  notification_metadata  = each.value.notification_metadata != "" ? each.value.notification_metadata : null
  notification_target_arn = each.value.notification_target_arn != "" ? each.value.notification_target_arn : null
  role_arn               = each.value.role_arn != "" ? each.value.role_arn : null
}
