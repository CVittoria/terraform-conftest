variable "bucket_name" {
  description = "Name of the bucket to create."
  type        = string
}

variable "canned_acl" {
  description = "Canned ACL policy for S3 bucket. Reference [docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl) for valid options and what they do."
  type        = string

  validation {
    condition     = contains(["private", "public-read", "public-read-write", "aws-exec-read", "authenticated-read", "bucket-owner-read", "bucket-owner-full-control", "log-delivery-write"], var.canned_acl)
    error_message = "Invalid canned ACL, should be one of: 'private', 'public-read', 'public-read-write', 'aws-exec-read', 'authenticated-read', 'bucket-owner-read', 'bucket-owner-full-control', 'log-delivery-write'."
  }
}

variable "tags" {
  description = "Map of tags to attach to the s3 bucket resource."
  type        = map(string)
}
