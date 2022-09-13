# VPC Data Module

This module takes a map of tags as input to find the matching VPC and outputs a bunch of helpful information. Assumes only 1 VPC will be returned by matching tags. Used as a building block module to break up monolithic terraform/terragrunt without moving "core" infrastructure. Can be safely called anywhere to get information you need! If `vpc_tags` isn't provided, module returns the default VPC for the region.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Map of tags to filter VPC's by. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_cidrs"></a> [subnet\_cidrs](#output\_subnet\_cidrs) | n/a |
| <a name="output_subnet_id_by_az"></a> [subnet\_id\_by\_az](#output\_subnet\_id\_by\_az) | n/a |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->
