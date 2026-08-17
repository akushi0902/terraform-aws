################################################################################
# Launch Template
################################################################################

output "launch_template_id" {
  description = "ID of the launch template."
  value       = var.create_launch_template ? aws_launch_template.this[0].id : var.external_launch_template_id
}

output "launch_template_arn" {
  description = "ARN of the launch template."
  value       = var.create_launch_template ? aws_launch_template.this[0].arn : null
}

output "launch_template_name" {
  description = "Name of the launch template."
  value       = var.create_launch_template ? aws_launch_template.this[0].name : null
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template."
  value       = var.create_launch_template ? aws_launch_template.this[0].latest_version : null
}

################################################################################
# Auto Scaling Group
################################################################################

output "autoscaling_group_id" {
  description = "ID of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.arn
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_min_size" {
  description = "Minimum size of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.min_size
}

output "autoscaling_group_max_size" {
  description = "Maximum size of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.max_size
}

output "autoscaling_group_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.desired_capacity
}

output "autoscaling_group_availability_zones" {
  description = "Availability zones of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  description = "VPC zone identifiers (subnet IDs) of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.vpc_zone_identifier
}

output "autoscaling_group_health_check_type" {
  description = "Health check type of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.health_check_type
}

################################################################################
# Scaling Policies
################################################################################

output "scale_up_policy_arn" {
  description = "ARN of the scale-up Auto Scaling policy."
  value       = var.create_scaling_policies ? aws_autoscaling_policy.scale_up[0].arn : null
}

output "scale_down_policy_arn" {
  description = "ARN of the scale-down Auto Scaling policy."
  value       = var.create_scaling_policies ? aws_autoscaling_policy.scale_down[0].arn : null
}

output "target_tracking_policy_arn" {
  description = "ARN of the target tracking Auto Scaling policy."
  value       = var.create_target_tracking_policy ? aws_autoscaling_policy.target_tracking[0].arn : null
}

################################################################################
# Scheduled Actions
################################################################################

output "scheduled_action_names" {
  description = "Names of the scheduled actions created for the Auto Scaling Group."
  value       = keys(aws_autoscaling_schedule.this)
}
