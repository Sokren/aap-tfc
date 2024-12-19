terraform {
  required_providers {
    aap = {
      source  = "tfo-apj-demos/aap"
      version = "1.0.2"
    }
  }
}

data "terraform_remote_state" "aws-ec2" {
  backend = "remote"

  config = {
    organization = var.tfc_org
    workspaces = {
      name = "AAP-TFE-aws-ec2"
    }
  }
}