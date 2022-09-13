# terraform-rego

An example repo for demonstrating an end-to-end Terraform module build & deploy workflow. 

* Modules tested with terratest to validate functionality
* Terraform plans validated against Open Policy Agent (OPA) policies. Reference Atlantis and conftest integration [docs](https://www.runatlantis.io/docs/policy-checking.html#how-it-works)

It's designed to be usable with an AWS free-tier account. 

## Provided Examples

### vpc_data Module

This module gives an example of a "data module" that doesn't create any new resources but reads the existing AWS account state and provides outputs for use by other modules. Useful for splitting monolithic Terraform into domain-specific Terraform repos with distributed ownership deployed onto a common network layer.

Illustrates an example of filtering out non-resource objects from a Terraform plan-file to skip evaluation of OPA policies.

### s3_bucket Module

A basic S3 Bucket module to illustrate a "real-world" example of using OPA policies to enforce organizational and security best-practices while using a generic module. This allows developers to use off-the-shelf Terraform modules for self-service infrastructure management while codifying governance as code-based policies. These policies can be run locally using `conftest` so there's no apply-time surprises (for ex, when using AWS Tagging Policies these are only enforced at resource creation) and speed up infra development. 

Central teams (SRE, InfoSec) can provide a means of deploying infrastructure (Atlantis) with transparent policy sets (OPA) to enable a growing set of product teams. SRE can then dedicate its time to improving product performance and visibility than remediating infrastructure compliance and best-practice.

## How To Run

First, modify the `terraform/assume_role.yaml` file to have your AWS account details.

The Makefile has all instructions required to build & run the docker env. Docker commands for reference:

* docker.build - Builds the docker image
* docker.run - Runs the provided Make command inside the built docker image.

To use `docker.run`, set your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables and pass the desired Make command (listed below) as an env var:

```
COMMAND=hello-world ARGS=<any_additional_docker_args> make docker.run
```

This will pass the command to the root Makefile and demo functionality. Commands listed below:

* hello-world - Validate docker environment was configured correctly
* vpc_data.conftest - Run conftest policy checking against the VPC Data Module.
* vpc_data.terratest - Run terratest module validation against the VPC Data Module.
* s3_bucket.conftest - Run conftest policy checking against the S3 Bucket Module.
* s3_bucket.terratest - Run terratest module validation against the S3 Bucket Module.

## Contributing

Configured to use [devcontainers](https://github.com/microsoft/vscode-dev-containers), development can be done on a local workstation or remote host with Docker and Git installed. 

### Requirements

* Docker
* Git
* VSCode

### Init Dev Environment

The devcontainer uses the env vars: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to manage authentication with the AWS API. These env vars are inherited from the host's `~/.bash_profile` file. Recommended to store your credentials in a keyring (similar to the keyring backend for aws-vault) and create export definitions within your `~/.bash_profile`, example below using `pass`:

```
$ cat ~/.bash_profile
export AWS_ACCESS_KEY_ID="$(pass AWS_ACCESS_KEY_ID)"
export AWS_SECRET_ACCESS_KEY="$(pass AWS_SECRET_ACCESS_KEY)"
```

Using VSCode with the Remote Containers extension, run the following command: `Remote Containers: Open Folder in Container...` and select the repo directory. This will build the devcontainer and configure your dev environment - use `make hello-world` to validate all tools were installed and configured correctly.
