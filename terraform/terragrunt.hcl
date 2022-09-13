# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  assume_role     = yamldecode(file(find_in_parent_folders("local_role.yaml", "assume_role.yaml")))
  aws_assume_role = local.assume_role["aws_assume_role"]
  aws_account_id  = local.assume_role["aws_account_id"]
  region          = yamldecode(file("region.yaml"))
  aws_region      = local.region["aws_region"]
}

# This generates a file provider.tf that includes the provider configuration block.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region              = "${local.aws_region}"
      allowed_account_ids = ["${local.aws_account_id}"]
      assume_role {
        role_arn     = "${local.aws_assume_role}"
        session_name = "terraform-conftest_sesh"
      }
    }
  EOF
}

inputs = {
  aws_region     = local.aws_region
  assume_role    = local.aws_assume_role
  aws_account_id = local.aws_account_id
}
