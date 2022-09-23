package tagging

import future.keywords

injson_tags := {"variables": {"tags": {"value": {
	"name": "myname",
	"environment": "myenv",
	"owner": "myowner",
	"description": "mydesc",
}}}}

test_allow_tags if {
	count(deny) == 0 with input as injson_tags
		with data.common.resources_exist as true
		with data.common.print_msg as null
}

injson_custom_tags := {"variables": {"custom_tags": {"value": {
	"name": "myname",
	"environment": "myenv",
	"owner": "myowner",
	"description": "mydesc",
}}}}

test_allow_custom_tags if {
	count(deny) == 0 with input as injson_custom_tags
		with data.common.resources_exist as true
		with data.common.print_msg as null
}

injson_deny_tags := {"variables": {"tags": {"value": {
	"Name": "myname",
	"environment": "myenv",
}}}}

test_deny_tags if {
	count(deny) > 0 with input as injson_deny_tags
		with data.common.resources_exist as true
		with data.common.print_msg as null
}

injson_deny_custom_tags := {"variables": {"custom_tags": {"value": {
	"Name": "myname",
	"environment": "myenv",
}}}}

test_deny_custom_tags if {
	count(deny) > 0 with input as injson_deny_custom_tags
		with data.common.resources_exist as true
		with data.common.print_msg as null
}
