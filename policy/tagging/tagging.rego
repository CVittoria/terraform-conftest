package tagging

import data.common.resources_exist
import data.common.print_msg
import future.keywords

#every resource might need these tags
minimum_required_tags := [
	"name",
	"environment",
	"owner",
	"description",
]

default tags = {}

default custom_tags = {}

# Tags can be present either in tags or custom_tags, depending on module.
tags := input.variables.tags.value

custom_tags := input.variables.custom_tags.value

merged_tags := object.union(tags, custom_tags)

keys := {key | merged_tags[key]}

tests := test if {
	resources_exist
}

test[msg] {
	test_tag := minimum_required_tags[_]
	not test_tag in keys
	msg := sprintf("Required tag missing: `%v`", [test_tag])
}

deny[msg] {
	print_msg(resources_exist, "No resources in module - skipping tag check.", "Resources found - checking tags")
	msg := tests[_]
}
