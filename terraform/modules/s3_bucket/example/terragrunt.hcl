# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../."
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  bucket_name = "terratest-bucket-${include.root.inputs.aws_account_id}"
# Change this to any of the "public" policies to actuate the s3 policy - example commented to the right.
  canned_acl  = "private" #"public-read"
  tags = {
    "name"        = "terratest-bucket-${include.root.inputs.aws_account_id}",
    "environment" = "test",
    "owner"       = "terratest",
# Commenting or uncommenting the below tag will actuate the tagging policy
    "description" = "Bucket created by terratest for s3_bucket module tests.",
  }
}
