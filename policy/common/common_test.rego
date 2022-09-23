package common

import future.keywords

injson := {"resource_changes": [{"address": "some_resource", "mode": "managed", "type": "some_resource", "change": {"actions": ["create"]}}]}

test_resources if {
	resources[0].address == "some_resource" with input as injson
}

injson_data := {"resource_changes": [{"address": "some_data", "mode": "data", "type": "some_data", "change": {"actions": ["create"]}}]}

test_resources_data if {
	not resources[0].address == "some_data" with input as injson_data
}

test_resources_exist if {
	resources_exist with input as injson
}

test_resources_exist_false if {
	not resources_exist with input as injson_data
}

test_created_resources if {
	count(all_created_resources) > 0 with input as injson
}

test_created_resources_data if {
	count(all_created_resources) == 0 with input as injson_data
}

test_filter_resources if {
	filter_resources("some_resource")[0].address == "some_resource" with input as injson
}

test_filter_resources_data if {
	not filter_resources("some_data")[0].address == "some_data" with input as injson_data
}

test_filtered_created_resources if {
	filtered_created_resources("some_resource")[0].address == "some_resource" with input as injson
}

test_filtered_created_resources_data if {
	not filtered_created_resources("some_data")[0].address == "some_data" with input as injson_data
}
