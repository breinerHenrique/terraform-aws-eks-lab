module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name            = local.vpc_name
  cidr            = local.cidr
  azs             = local.azs
  private_subnets = local.private_subnets_cidr
  public_subnets  = local.public_subnets_cidr

  enable_nat_gateway         = true
  single_nat_gateway         = true
  enable_dns_hostnames       = true
  enable_dns_support         = true
  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  tags                = var.tags
  private_subnet_tags = local.private_subnet_tags
  public_subnet_tags  = local.public_subnet_tags
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  tags = var.tags

  workers_group_defaults = {
    key_name = local.node_groups_key_name
    #  enable_monitoring = local.node_groups_enable_monitoring
    root_volume_type = "gp2"
    root_volume_size = 12
  }

  node_groups_defaults = {
    create_launch_template = true
    ami_type               = "AL2_x86_64"
    disk_size              = local.node_groups_disk_size
  }
  node_groups = local.node_groups_config
  map_roles   = local.roles_aws_auth
  map_users   = local.users_aws_auth
}
