terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "${var.project_name}-tf-state-${var.region}"
  table_name  = "${var.project_name}-tf-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "${var.project_name}-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "${var.project_name}-repo"
  scan_on_push = true
}
