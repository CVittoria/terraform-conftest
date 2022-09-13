resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = var.canned_acl
}
