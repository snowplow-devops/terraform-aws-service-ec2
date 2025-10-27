variable "user_supplied_script" {
  description = "The user-data script extension to execute"
  type        = string
}

variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}

# --- Launch Template

variable "amazon_linux_2023_ami_id" {
  description = "The AMI ID to use which must be based of of Amazon Linux 2023; by default the latest community version is used"
  default     = ""
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "ssh_key_name" {
  description = "The name of the SSH key-pair to attach to all EC2 nodes deployed"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the launch template"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public ip address to this instance"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "A list of security groups to associate with the launch template"
  type        = list(string)
  default     = []
}

variable "root_block_device_name" {
  description = "The name of the root block device for the AMI being used"
  type        = string
  default     = "/dev/xvda"
}

variable "root_block_device_volume_type" {
  description = "The type of volume to assign to the root block device"
  type        = string
  default     = "gp3"
}

variable "root_block_device_volume_size_gb" {
  description = "The size of the root block device in gb"
  type        = number
  default     = 10
}

variable "metadata_http_tokens" {
  description = "Whether to enforce IMDSv2 on the metadata service (Options: required, optional)"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 2
}

# --- Auto Scaling Group

variable "min_size" {
  description = "The minimum number of servers in this server-group"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "The maximum number of servers in this server-group"
  default     = 2
  type        = number
}

variable "health_check_grace_period_sec" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
  type        = number
}

variable "health_check_type" {
  description = "EC2 or ELB - controls how health checking is done"
  default     = "EC2"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy across"
  type        = list(string)
}

variable "target_group_arns" {
  description = "The list of target groups to associate the ASG with"
  type        = list(string)
  default     = []
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Percentage of ASG that must remain healthy during an instance refresh for the process to continue"
  default     = 90
  type        = number
}

# --- Auto Scaling Policies

variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling policies for the service"
  default     = true
  type        = bool
}

variable "scale_up_cooldown_sec" {
  description = "Time (in seconds) until another scale-up action can occur"
  default     = 180
  type        = number
}

variable "scale_up_cpu_threshold_percentage" {
  description = "The average CPU percentage that must be exceeded to scale-up"
  default     = 60
  type        = number
}

variable "scale_up_eval_minutes" {
  description = "The number of consecutive minutes that the threshold must be breached to scale-up"
  default     = 5
  type        = number
}

variable "scale_down_cooldown_sec" {
  description = "Time (in seconds) until another scale-down action can occur"
  default     = 600
  type        = number
}

variable "scale_down_cpu_threshold_percentage" {
  description = "The average CPU percentage that we must be below to scale-down"
  default     = 20
  type        = number
}

variable "scale_down_eval_minutes" {
  description = "The number of consecutive minutes that we must be below the threshold to scale-down"
  default     = 60
  type        = number
}
