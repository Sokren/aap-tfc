resource "tfe_project" "CustomerRH-Demo" {
  organization = data.tfe_organization.org.name
  name = "AAP-TFC"
}

data "tfe_team" "RH-Team" {
  name         = "RH"
  organization = data.tfe_organization.org.name
}

resource "tfe_team_project_access" "admin-role" {
  access       = "admin"
  team_id      = data.tfe_team.RH-Team.id
  project_id   = tfe_project.CustomerRH-Demo.id
}

data "tfe_team" "SE-France" {
  name         = "SE-France"
  organization = data.tfe_organization.org.name
}

resource "tfe_team_project_access" "admin-role-SE" {
  access       = "admin"
  team_id      = data.tfe_team.SE-France.id
  project_id   = tfe_project.CustomerRH-Demo.id
}

data "tfe_variable_set" "Aws-creds" {
  name         = "Aws-creds"
  organization = data.tfe_organization.org.name
}

resource "tfe_project_variable_set" "Aws-creds-CustomerRH-Demo" {
  variable_set_id = data.tfe_variable_set.Aws-creds.id
  project_id      = tfe_project.CustomerRH-Demo.id
}

data "tfe_variable_set" "hcp-creds" {
  name         = "hcp-creds"
  organization = data.tfe_organization.org.name
}

resource "tfe_project_variable_set" "hcp-creds-CustomerRH-Demo" {
  variable_set_id = data.tfe_variable_set.hcp-creds.id
  project_id      = tfe_project.CustomerRH-Demo.id
}