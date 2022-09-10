package common

# all resources being changed in the plan
resources = all {
	all := [name |
		name := input.resource_changes[_]
		not name.mode == "data"
	]
}

# all resources being created in the plan
all_created_resources = all {
	all := created_resources(resources)
}

# check if plan is for a data module
resources_exist = bool {
	bool := count(resources) > 0
}

# only the resources being created by the plan
created_resources(res_array) = created {
	created := [res | res := res_array[_]; res.change.actions[_] == "create"]
}

# filter resources by type
filter_resources(resource_type) = filtered {
	filtered := [name |
		name := resources[_]
		name.type == resource_type
	]
}

# filter created resources by type
filtered_created_resources(resource_type) = created {
	created := created_resources(filter_resources(resource_type))
}
