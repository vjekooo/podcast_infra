terraform {
  backend "s3" {
    bucket = "podcast-tfstate"
    key    = "podcast.tfstate"
    region = "eu-west-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "eu-west-1"
  version    = "~> 3.0"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  prefix = "${var.prefix}-production"
  common_tags = {
    Environment = "production"
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}