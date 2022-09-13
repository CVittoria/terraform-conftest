terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }
}

locals {
  fetch_default_vpc = var.vpc_tags == null ? true : false
}

data "aws_vpc" "data" {
  tags    = var.vpc_tags
  default = local.fetch_default_vpc
}

data "aws_subnets" "data" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.data.id]
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.data.ids)
  id       = each.value
}

locals {
  subnet_az_map   = { for id, subnet in data.aws_subnet.subnets : subnet.availability_zone => id... }
  subnet_cidr_map = { for id, subnet in data.aws_subnet.subnets : id => subnet.cidr_block }
}
