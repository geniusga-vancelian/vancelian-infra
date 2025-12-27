terraform {
  backend "s3" {
    bucket         = "vancelian-tfstate-411714852748-me-central-1"
    key            = "dev/terraform.tfstate"
    region         = "me-central-1"
    dynamodb_table = "vancelian-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "me-central-1"
}

module "network" {
  source = "../../modules/network"

  name     = "vancelian-dev"
  vpc_cidr = "10.10.0.0/16"

  public_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
  private_subnet_cidrs = ["10.10.20.0/24", "10.10.21.0/24"]

  tags = {
    Project = "vancelian"
    Env     = "dev"
  }
}

module "ecr_api" {
  source = "../../modules/ecr"
  name   = "vancelian-api"
  tags = {
    Project = "vancelian"
    Env     = "dev"
  }
}
module "ecs_api" {
  source = "../../modules/ecs_alb_service"

  name               = "vancelian-dev-api"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  ecr_image = module.ecr_api.repository_url
  image_tag = "latest"

  container_name   = "api"
  container_port   = 8000
  healthcheck_path = "/"

  desired_count = 1

  tags = {
    Project = "vancelian"
    Env     = "dev"
  }
}

output "alb_dns_name" {
  value = module.ecs_api.alb_dns_name
}
output "ecr_api_url" {
  value = module.ecr_api.repository_url
}

output "vpc_id" {
  value = module.network.vpc_id
}
output "env" {
  value = "dev"
}


