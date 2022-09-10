hello-world:
	echo "Hello World!"
	terraform --version
	terragrunt --version
	terraform-docs --version
	go version
	conftest --version

# TODO: Make a bunch of conftest.<var> commands for running conftest against various plan.json's
#conftest.:

# TODO: Make a bunch of terratest.<var> commands for running terratest against various modules
#terratest.:
