variable "vpc_tags" {
  description = "Map of tags to filter VPC's by."
  type        = map(string)
  default     = null
}
