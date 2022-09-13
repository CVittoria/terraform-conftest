package main

import data.common.resources_exist
import data.common.test_msg
import future.keywords.if

#every resource might need these tags
minimum_required_tags := [
	"name",
	"environment",
	"owner",
	"description",
]

#each resourse type might have additional custom tags in another list
tags := input.variables.tags.value

keys := {key | tags[key]}

tags_contain_proper_keys(tag) := check if {
	set := {tag}
	intersect := keys & set

	check = count(intersect) == 0
}

tests := test if {
	resources_exist
}

test[msg] {
	test_tag := minimum_required_tags[_]
	tags_contain_proper_keys(test_tag)
	msg := sprintf("Required tag missing: `%v`", [test_tag])
}

deny[msg] {
	test_msg(resources_exist, "No resources in module - skipping tag check.", "Resources found - checking tags")
	msg := tests[_]
}
