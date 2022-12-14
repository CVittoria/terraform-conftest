package s3

import data.common.filter_resources
import data.common.filtered_created_resources
import data.common.print_msg

import future.keywords.if

s3_buckets := filter_resources("aws_s3_bucket")

bucket_acls := filtered_created_resources("aws_s3_bucket_acl")

buckets_exist = bool if {
	bool := count(s3_buckets) > 0
}

check_bucket_acl(acl) := check if {
	pattern := "^public.*$"
	check := regex.match(pattern, acl)
}

tests := test if {
	buckets_exist
}

test[msg] {
	acl := bucket_acls[_].change.after.acl

	check_bucket_acl(acl)

	msg := "Public ACL attached to bucket. No public access buckets allowed!"
}

deny[msg] {
	print_msg(buckets_exist, "No aws_s3_bucket in plan - skipping bucket check.", "aws_s3_bucket found in plan - checking s3 policies.")
	msg := tests[_]
}
