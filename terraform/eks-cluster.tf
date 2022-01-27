module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = {
    "terraform"   = "true"
    "environment" = "lab"
    "project"     = "ekslabs"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
    root_volume_size = 20
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3a.small" #Define qual tipo de instância EC2 será utilizada como node do cluster
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 2 #Define a quantidade de nodes nesse work group
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3a.small" #Define qual tipo de instância EC2 será utilizada como node do cluster
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1 #Define a quantidade de nodes nesse work group
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}