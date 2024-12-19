resource "tfe_organization_run_task" "hcp_packer" {
  organization = var.tfc_org
  url          = var.hcp_packer_url
  name         = "HCP-Packer"
  hmac_key     = var.hcp_packer_hmac
  enabled      = true
  description  = "HCP Packer run task"
}

resource "tfe_workspace_run_task" "hcp_packer_aws_ec2" {
  workspace_id      = tfe_workspace.aws_ec2.id
  task_id           = tfe_organization_run_task.hcp_packer.id
  enforcement_level = "advisory"
}