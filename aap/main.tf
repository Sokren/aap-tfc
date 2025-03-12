terraform {
  required_providers {
    aap = {
#      source  = "tfo-apj-demos/aap"
#      version = "1.0.2"
      source  = "ansible/terraform-provider-aap"
      version = "1.1.2"
    }
  }
}

data "terraform_remote_state" "aws-ec2" {
  backend = "remote"

  config = {
    organization = var.tfc_org
    workspaces = {
      name = "AAP-TFC-aws-ec2"
    }
  }
}
