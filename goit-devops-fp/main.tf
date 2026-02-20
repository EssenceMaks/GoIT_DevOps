terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

module "s3_backend" {
  source              = "./modules/s3-backend"
  bucket_name         = "${var.project_name}-tf-state-${var.region}"
  dynamodb_table_name = "${var.project_name}-tf-locks"
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  cluster_name = var.cluster_name
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = "${var.project_name}-repo"
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.public_subnet_ids
}

module "rds" {
  source                = "./modules/rds"
  project_name          = var.project_name
  db_name               = "djangodb"
  db_username           = var.db_username
  db_password           = var.db_password
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  eks_security_group_id = module.eks.cluster_security_group_id

  # Universal Module Configuration
  use_aurora     = false # Set to true to switch to Aurora
  engine         = "postgres"
  engine_version = "16.6"
  instance_class = "db.t3.micro"
}

# Fix for RDS EKS SG ID:
# The EKS module currently only outputs endpoint, name, CA. 
# I need to update EKS module to output security group ID if I want to reference it cleanly. 
# Or I can use data source in RDS module? 
# Better to update EKS module. I'll add a todo for that or just update it now.

module "jenkins" {
  source         = "./modules/jenkins"
  namespace      = "jenkins"
  admin_password = var.jenkins_admin_password
  depends_on     = [module.eks]
}

module "argo_cd" {
  source     = "./modules/argo_cd"
  namespace  = "argocd"
  depends_on = [module.eks]
}

module "monitoring" {
  source                 = "./modules/monitoring"
  namespace              = "monitoring"
  grafana_admin_password = var.grafana_admin_password
  depends_on             = [module.eks]
}
