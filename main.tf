locals {
  user_data = templatefile("${path.module}/templates/user-data.sh.tmpl", {
    user_supplied_script = var.user_supplied_script
  })
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# --- EC2: Auto-scaling group & Launch Configurations

resource "aws_launch_template" "lt" {
  name_prefix = "${var.name}-"

  image_id      = var.amazon_linux_2_ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.amazon_linux_2_ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = base64encode(local.user_data)

  network_interfaces {
    # Note: Required if deployed in a public subnet
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
  }

  block_device_mappings {
    device_name = var.root_block_device_name

    ebs {
      volume_type           = var.root_block_device_volume_type
      volume_size           = var.root_block_device_volume_size_gb
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

module "tags" {
  source  = "snowplow-devops/tags/aws"
  version = "0.2.0"

  tags = var.tags
}

resource "aws_autoscaling_group" "asg" {
  name = var.name

  max_size = var.max_size
  min_size = var.min_size

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }

  health_check_grace_period = var.health_check_grace_period_sec
  health_check_type         = var.health_check_type

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupInServiceInstances"]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
    }
    triggers = ["tag"]
  }

  tags = module.tags.asg_tags
}

# --- CloudWatch: Scaling

resource "aws_autoscaling_policy" "scale_up" {
  count = var.enable_auto_scaling ? 1 : 0

  name                   = "${var.name}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_up_cooldown_sec
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "scale_down" {
  count = var.enable_auto_scaling ? 1 : 0

  name                   = "${var.name}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_down_cooldown_sec
  scaling_adjustment     = -1
}

# --- CloudWatch: Alarms

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = var.enable_auto_scaling ? 1 : 0

  alarm_name          = "${var.name}-cpu-high"
  evaluation_periods  = var.scale_up_eval_minutes
  statistic           = "Average"
  threshold           = var.scale_up_cpu_threshold_percentage
  alarm_description   = "CPU usage has been above ${var.scale_up_cpu_threshold_percentage} percent for ${var.scale_up_eval_minutes} minutes"
  period              = 60
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "CPUUtilization"
  unit                = "Percent"
  namespace           = "AWS/EC2"

  alarm_actions = [
    join("", aws_autoscaling_policy.scale_up.*.arn)
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = var.enable_auto_scaling ? 1 : 0

  alarm_name          = "${var.name}-cpu-low"
  evaluation_periods  = var.scale_down_eval_minutes
  statistic           = "Average"
  threshold           = var.scale_down_cpu_threshold_percentage
  alarm_description   = "CPU usage has been below ${var.scale_down_cpu_threshold_percentage} percent for ${var.scale_down_eval_minutes} minutes"
  period              = 60
  comparison_operator = "LessThanThreshold"
  metric_name         = "CPUUtilization"
  unit                = "Percent"
  namespace           = "AWS/EC2"

  alarm_actions = [
    join("", aws_autoscaling_policy.scale_down.*.arn)
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}
