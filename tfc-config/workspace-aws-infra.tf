resource "tfe_workspace" "aws_infra" {
  name         = "AAP-TFC-aws-infra"
  organization = data.tfe_organization.org.name
  queue_all_runs = false
  vcs_repo {
    branch = "main"
    identifier = "Sokren/Customer-RH"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
  working_directory = "/aws-infra"
  trigger_patterns = ["/aws-infra/*.tf"]
  project_id = tfe_project.AAP-TFC-Demo.id
  remote_state_consumer_ids = [
    tfe_workspace.aws_ec2.id
  ]
}

resource "tfe_variable" "aws_infra_org" {
  key          = "tfc_org"
  value        = var.tfc_org
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "Terraform Cloud Org Name"
}

resource "tfe_variable" "aws_tag" {
  key          = "tag"
  value        = var.aws_resources_tag
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "AWS resources tag"
}

resource "tfe_variable" "aws_region" {
  key          = "region"
  value        = var.aws_region
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "AWS region"
}

resource "tfe_variable" "myip" {
  key          = "myip"
  value        = var.myip
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "Your IP for backdoor"
}

resource "tfe_variable" "db_name" {
  key          = "db_name"
  value        = var.aws_rds_db_name
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "RDS postgres database name"
}

resource "tfe_variable" "db_username" {
  key          = "db_username"
  value        = var.aws_rds_db_username
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "RDS username"
}

resource "tfe_variable" "db_pwd" {
  key          = "db_pwd"
  value        = var.aws_rds_db_pwd
  sensitive    = true
  category     = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description  = "RDS user password"
}

resource "tfe_variable" "aws_access_key_id" {
  key = "AWS_ACCESS_KEY_ID"
  value = var.aws_access_key_id
  category = "env"
  workspace_id = tfe_workspace.aws_infra.id
  description = "AWS Access Key ID"
}

resource "tfe_variable" "aws_secret_access_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.aws_secret_access_key
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.aws_infra.id
  description = "AWS Secret Access Key"
}

resource "tfe_variable" "aws_s3_bucket_name" {
  key = "bucket_name"
  value = var.session_rec_s3_name
  category = "terraform"
  workspace_id = tfe_workspace.aws_infra.id
  description = "AWS S3 bucket name for session recording"
}