module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.Available.names

  # private subnet
  private_subnet_names  = local.private_subnet_names
  private_subnets       = local.pvt_sub
  private_subnet_suffix = "private-routetable"

  # public subnet
  public_subnet_names  = local.public_subnet_names
  public_subnets       = local.pub_sub
  public_subnet_suffix = "public-routetable"

  enable_vpn_gateway = false

  # nat gateway
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_network_acl    = false

  igw_tags = {
    Name = "${var.env}-IGW"
  }

  vpc_tags = {
    Name = var.vpc_name
  }

  nat_eip_tags = {
    Name = "${var.env}-eip"
  }

  nat_gateway_tags = {
    Name = "${var.env}-NAT"
  }

}
