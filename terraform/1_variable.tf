variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_name" {
  default = "ekslabs"
}

variable "cluster_name" {
  default = "ekslabs"
}

variable "cluster_version" {
  default = "1.21"
}

variable "tags" {
  type = map(string)
  default = {
    "terraform"   = "true"
    "environment" = "lab"
    "project"     = "ekslabs"
  }
}