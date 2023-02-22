output "asg_id" {
  value       = aws_autoscaling_group.asg.id
  description = "ID of the ASG"
}

output "asg_name" {
  value       = aws_autoscaling_group.asg.name
  description = "Name of the ASG"
}
