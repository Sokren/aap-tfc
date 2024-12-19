terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.99.0"
    }
  }
}

data "terraform_remote_state" "aws_infra" {
  backend = "remote"
  config = {
    organization = var.tfc_org
    workspaces = {
      name = "AAP-TFE-aws-infra"
    }
  }
}


provider "aws" {
  region  = var.region
}

resource "random_pet" "test" {
  length = 1
}
