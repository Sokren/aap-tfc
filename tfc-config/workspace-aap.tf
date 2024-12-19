resource "tfe_workspace" "aap" {
  name         = "AAP-TFC-aap"
  organization = data.tfe_organization.org.name
  queue_all_runs = false
  vcs_repo {
    branch = "main"
    identifier = "Sokren/aap-tfc"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
  working_directory = "/aap"
  trigger_patterns = ["/aap/*.tf"]
  project_id = tfe_project.AAP-TFC-Demo.id
}

resource "tfe_variable" "aap_tfc_org" {
  key          = "tfc_org"
  value        = var.tfc_org
  category     = "terraform"
  workspace_id = tfe_workspace.aap.id
  description  = "Terraform Cloud Org Name"
}

resource "tfe_variable" "aap_job_template_id" {
  key          = "job_template_id"
  value        = "14"
  category     = "terraform"
  workspace_id = tfe_workspace.aap.id
  description  = "ID of the job template"
}

data "tfe_variable_set" "rh-aap" {
  name         = "RH-AAP"
  organization = data.tfe_organization.org.name
}

resource "tfe_workspace_variable_set" "rh-aap-AAP-TFC-Demo" {
  variable_set_id   = data.tfe_variable_set.rh-aap.id
  workspace_id      = tfe_workspace.aap.id
}