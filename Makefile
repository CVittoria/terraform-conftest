.PHONY: hello-world
hello-world:
	echo "Hello World!"
	terraform --version
	terragrunt --version
	terraform-docs --version
	go version
	conftest --version

json-plan = terragrunt plan -out="$$(pwd)/plan" && terragrunt show -json plan | jq > plan.json && rm plan

workspace-setup = cd $(1)

clean = rm -rf $(1).terragrunt-cache/ && rm -f $(1).terraform.lock.hcl

go-mod-tidy = go mod tidy

docker.build:
	docker build -t terraform-conftest:latest .

.SILENT: docker.run
docker.run: docker.build
	docker run $(ARGS) -v $(pwd)/.git:/root/.git:ro -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} terraform-conftest:latest $(COMMAND)

terraform-docs:
	$(call workspace-setup,terraform) && \
	terraform-docs $(MODULE_PATH)

vpc_data.conftest:
	$(call workspace-setup,terraform/modules/vpc_data/example) && \
	$(call json-plan) && \
	conftest test plan.json -p  $$(git rev-parse --show-toplevel)/policy ; \
	rm plan.json ; \
	$(call clean)

vpc_data.terratest:
	$(call workspace-setup,terraform/modules/vpc_data) && \
	$(call go-mod-tidy) && \
	go test -v . ; \
	$(call clean,**/)

s3_bucket.conftest:
	$(call workspace-setup,terraform/modules/s3_bucket/example) && \
	$(call json-plan) && \
	conftest test plan.json -p  $$(git rev-parse --show-toplevel)/policy ; \
	rm plan.json ; \
	$(call clean)

s3_bucket.terratest:
	$(call workspace-setup,terraform/modules/s3_bucket) && \
	$(call go-mod-tidy) && \
	go test -v . ; \
	$(call clean,**/)
