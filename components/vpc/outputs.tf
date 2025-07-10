output "pub_subnet_names" {
  value = local.public_subnet_names
}
output "pvt_subnet_names" {
  value = local.private_subnet_names
}

output "pub_subnet_ids" {
  value = module.vpc.public_subnets
}
output "pvt_subnet_ids" {
  value = module.vpc.private_subnets
}

output "azs" {
  value = data.aws_availability_zones.Available.names
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

