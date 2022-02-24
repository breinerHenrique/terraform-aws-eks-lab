locals {
  cluster_version = var.cluster_version

  node_groups_key_name          = "breiner-ekslab"
  node_groups_enable_monitoring = false
  node_groups_disk_size         = 12
  node_groups_force_update      = false
  node_groups_config = {
    "system" = {
      name             = "nodes-system-${random_string.suffix.result}"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3a.small"]
      # k8s_labels = {
      #   "node_name"                = "nodes-system"
      #   "node/reserved-for"        = "system"
      #   "node_groups_force_update" = random_string.suffix.keepers.force_update
      # }
      additional_tags = {
        "Name" = "${local.cluster_name}-nodes-system"
        # "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
        # "k8s.io/cluster-autoscaler/enabled"               = "true"
        "environment" = "lab"
      }
      # update_config = {
      #   max_unavailable_percentage = 50
      # }
    },

    "default" = {
      name             = "nodes-default-${random_string.suffix.result}"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3a.small"]
      # k8s_labels = {
      #   "node_name"                = "nodes-default"
      #   "node_groups_force_update" = random_string.suffix.keepers.force_update
      # }
      additional_tags = {
        "Name" = "${local.cluster_name}-nodes-default"
        # "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
        # "k8s.io/cluster-autoscaler/enabled"               = "true"
        "environment" = "lab"
      }
      # update_config = {
      #   max_unavailable_percentage = 50
      # }
    },

    "nodes-app" = {
      name             = "nodes-app"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3a.small"]
      # k8s_labels = {
      #   "node_name"                = "nodes-app"
      #   "node_groups_force_update" = random_string.suffix.keepers.force_update
      # }
      additional_tags = {
        "Name" = "${local.cluster_name}-app"
        # "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
        # "k8s.io/cluster-autoscaler/enabled"               = "true"
        "environment" = "lab"
      }
      # update_config = {
      #   max_unavailable_percentage = 50
      # }
    }
  }

  roles_aws_auth = [
    {
      rolearn  = "arn:aws:iam::703301852772:role/ekslab-admin"
      username = "ekslab-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::703301852772:role/KubernetesAdmin"
      username = "KubernetesAdmin"
      groups   = ["system:masters"]
    }
  ]
  users_aws_auth = [
    {
      userarn  = "arn:aws:iam::703301852772:user/jenkins_service"
      username = "jenkins_service"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 4
  special = false
  keepers = {
    force_update = local.node_groups_force_update
  }
}