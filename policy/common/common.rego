package common

import future.keywords.if

# all resources being changed in the plan
resources = all if {
	all := [name |
		name := input.resource_changes[_]
		not name.mode == "data"
	]
}

# all resources being created in the plan
all_created_resources = all if {
	all := created_resources(resources)
}

# check if plan is for a data module
resources_exist = bool if {
	bool := count(resources) > 0
}

# only the resources being created by the plan
created_resources(res_array) = created if {
	created := [res | res := res_array[_]; res.change.actions[_] == "create"]
}

# filter resources by type
filter_resources(resource_type) = filtered if {
	filtered := [name |
		name := resources[_]
		name.type == resource_type
	]
}

# filter created resources by type
filtered_created_resources(resource_type) = created if {
	created := created_resources(filter_resources(resource_type))
}

# Use test_msg to conditionally display a message.
# Used for UX when a policy set may or may not be evaluated due to a condition.
# condition is a bool
# skip_msg is a string printed when "condition" is false
# continue_msg is a string printed when "condition" is true
print_msg(condition, skip_msg, continue_msg) if {
	condition
	print(continue_msg)
} else {
	print(skip_msg)
}
