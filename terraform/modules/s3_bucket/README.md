# S3 Bucket

Example module of a S3 bucket to illustrate policy enforcement against "broad-use" modules that expose all inputs to end-users. Simplified version of a "Off-the-shelf" terraform module.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket to create. | `string` | n/a | yes |
| <a name="input_canned_acl"></a> [canned\_acl](#input\_canned\_acl) | Canned ACL policy for S3 bucket. Reference [docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl) for valid options and what they do. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to attach to the s3 bucket resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | n/a |
<!-- END_TF_DOCS -->