[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry]

# terraform-aws-service-ec2

A Terraform module which forms the base of all `ec2` deployments for Snowplow OS services where we deploy an auto-scaling group of nodes running one or more services.  This module serves to reduce the boilerplate code that we incur otherwise to simplify maintenance across all of our OS modules.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | snowplow-devops/tags/aws | 0.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_launch_template.lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.amazon_linux_2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | The name of the IAM instance profile to associate with the launch template | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A name which will be pre-pended to the resources created | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | The name of the SSH key-pair to attach to all EC2 nodes deployed | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnets to deploy Enrich across | `list(string)` | n/a | yes |
| <a name="input_user_supplied_script"></a> [user\_supplied\_script](#input\_user\_supplied\_script) | The user-data script extension to execute | `string` | n/a | yes |
| <a name="input_amazon_linux_2023_ami_id"></a> [amazon\_linux\_2023\_ami\_id](#input\_amazon\_linux\_2023\_ami\_id) | The AMI ID to use which must be based of of Amazon Linux 2023; by default the latest community version is used | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to assign a public ip address to this instance | `bool` | `true` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | Whether to enable auto-scaling policies for the service | `bool` | `true` | no |
| <a name="input_health_check_grace_period_sec"></a> [health\_check\_grace\_period\_sec](#input\_health\_check\_grace\_period\_sec) | Time (in seconds) after instance comes into service before checking health | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | EC2 or ELB - controls how health checking is done | `string` | `"EC2"` | no |
| <a name="input_instance_refresh_min_healthy_percentage"></a> [instance\_refresh\_min\_healthy\_percentage](#input\_instance\_refresh\_min\_healthy\_percentage) | Percentage of ASG that must remain healthy during an instance refresh for the process to continue | `number` | `90` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of servers in this server-group | `number` | `2` | no |
| <a name="input_metadata_http_put_response_hop_limit"></a> [metadata\_http\_put\_response\_hop\_limit](#input\_metadata\_http\_put\_response\_hop\_limit) | The desired HTTP PUT response hop limit for instance metadata requests | `number` | `2` | no |
| <a name="input_metadata_http_tokens"></a> [metadata\_http\_tokens](#input\_metadata\_http\_tokens) | Whether to enforce IMDSv2 on the metadata service (Options: required, optional) | `string` | `"required"` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of servers in this server-group | `number` | `1` | no |
| <a name="input_root_block_device_name"></a> [root\_block\_device\_name](#input\_root\_block\_device\_name) | The name of the root block device for the AMI being used | `string` | `"/dev/xvda"` | no |
| <a name="input_root_block_device_volume_size_gb"></a> [root\_block\_device\_volume\_size\_gb](#input\_root\_block\_device\_volume\_size\_gb) | The size of the root block device in gb | `number` | `10` | no |
| <a name="input_root_block_device_volume_type"></a> [root\_block\_device\_volume\_type](#input\_root\_block\_device\_volume\_type) | The type of volume to assign to the root block device | `string` | `"gp3"` | no |
| <a name="input_scale_down_cooldown_sec"></a> [scale\_down\_cooldown\_sec](#input\_scale\_down\_cooldown\_sec) | Time (in seconds) until another scale-down action can occur | `number` | `600` | no |
| <a name="input_scale_down_cpu_threshold_percentage"></a> [scale\_down\_cpu\_threshold\_percentage](#input\_scale\_down\_cpu\_threshold\_percentage) | The average CPU percentage that we must be below to scale-down | `number` | `20` | no |
| <a name="input_scale_down_eval_minutes"></a> [scale\_down\_eval\_minutes](#input\_scale\_down\_eval\_minutes) | The number of consecutive minutes that we must be below the threshold to scale-down | `number` | `60` | no |
| <a name="input_scale_up_cooldown_sec"></a> [scale\_up\_cooldown\_sec](#input\_scale\_up\_cooldown\_sec) | Time (in seconds) until another scale-up action can occur | `number` | `180` | no |
| <a name="input_scale_up_cpu_threshold_percentage"></a> [scale\_up\_cpu\_threshold\_percentage](#input\_scale\_up\_cpu\_threshold\_percentage) | The average CPU percentage that must be exceeded to scale-up | `number` | `60` | no |
| <a name="input_scale_up_eval_minutes"></a> [scale\_up\_eval\_minutes](#input\_scale\_up\_eval\_minutes) | The number of consecutive minutes that the threshold must be breached to scale-up | `number` | `5` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security groups to associate with the launch template | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to append to this resource | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | The list of target groups to associate the ASG with | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | ID of the ASG |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Name of the ASG |

# Copyright and license

The Terraform AWS Service on EC2 project is Copyright 2023-2023 Snowplow Analytics Ltd.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[release]: https://github.com/snowplow-devops/terraform-aws-service-ec2/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-aws-service-ec2

[ci]: https://github.com/snowplow-devops/terraform-aws-service-ec2/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-aws-service-ec2/workflows/ci/badge.svg

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/service-ec2/aws/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform
