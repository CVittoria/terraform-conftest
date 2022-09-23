package s3

import future.keywords

injson_allow := [{
	"address": "aws_s3_bucket_acl.s3_bucket_acl",
	"mode": "managed",
	"type": "aws_s3_bucket_acl",
	"name": "s3_bucket_acl",
	"provider_name": "registry.terraform.io/hashicorp/aws",
	"change": {"after": {"acl": "private"}},
}]

test_allow if {
	count(deny) == 0 with bucket_acls as injson_allow
		with buckets_exist as true
		with data.common.print_msg as null
}

injson_deny := [{
	"address": "aws_s3_bucket_acl.s3_bucket_acl",
	"mode": "managed",
	"type": "aws_s3_bucket_acl",
	"name": "s3_bucket_acl",
	"provider_name": "registry.terraform.io/hashicorp/aws",
	"change": {"after": {"acl": "public-read"}},
}]

test_deny if {
	count(deny) > 0 with bucket_acls as injson_deny
		with buckets_exist as true
		with data.common.print_msg as null
}
