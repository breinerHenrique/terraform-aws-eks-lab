provider "aws" {
  region = var.region
}

locals {
  cluster_name = var.cluster_name
  region       = var.region
  vpc_name     = var.vpc_name

  cidr                 = "10.0.0.0/16"
  azs                  = ["${local.region}a", "${local.region}b"]
  private_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets_cidr  = ["10.0.100.0/24", "10.0.101.0/24"]

  tags = var.tags
  # tags = {
  #   "terraform"   = "true"
  #   "environment" = "lab"
  #   "project"     = "ekslabs"
  # }

  private_subnet_tags = {
    "kubernetes.io/cluster/ekslabs"   = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/ekslabs" = "shared"
    "kubernetes.io/role/elb"        = "1"
  }
}

data "aws_availability_zones" "available" {}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}  