output "vpc_id" {
  value = data.aws_vpc.data.id
}

output "subnet_ids" {
  value = data.aws_subnets.data.ids
}

output "subnet_cidrs" {
  value = local.subnet_cidr_map
}

output "subnet_id_by_az" {
  value = local.subnet_az_map
}

output "vpc_cidr_block" {
  value = data.aws_vpc.data.cidr_block
}
