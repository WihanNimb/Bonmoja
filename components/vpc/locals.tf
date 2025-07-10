locals {

  vpc_cidr       = var.vpc_cidr
  subnet_newbits = var.subnet_newbits

  AZ_Total      = var.AZ_Total
  pub_sub_total = var.pub_sub_total
  pvt_sub_total = var.pvt_sub_total

  #backend logic
  subnet_cidr_list = cidrsubnets(local.vpc_cidr, local.subnet_newbits...)
  pub_sub          = slice(local.subnet_cidr_list, 0, local.pub_sub_total)
  pvt_sub          = slice(local.subnet_cidr_list, (local.pub_sub_total), (local.pub_sub_total + local.pvt_sub_total))

  pub_sub_count       = range(0, length(local.pub_sub))
  public_subnet_names = [for n in local.pub_sub_count : format("sub-pub-%s-%d", substr(element(data.aws_availability_zones.Available.names, (tonumber(floor(n % tonumber(local.AZ_Total))))), -2, -1), (tonumber(floor(n / tonumber(local.AZ_Total))) + 1))]

  pvt_sub_count        = range(0, length(local.pvt_sub))
  private_subnet_names = [for n in local.pvt_sub_count : format("sub-pvt-%s-%d", substr(element(data.aws_availability_zones.Available.names, (tonumber(floor(n % tonumber(local.AZ_Total))))), -2, -1), (tonumber(floor(n / tonumber(local.AZ_Total))) + 1))]

}