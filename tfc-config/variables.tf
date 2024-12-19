variable "tfc_org" {
  type = string
}

variable "tfc_token" {
  type = string
}

variable "tfc_role_name" {
  type = string
}

variable "vcs_provider_name" {
  type = string
}

variable "github_username" {
  type = string
}

variable "aws_resources_tag" {
  type = string
}

variable "pub_ssh_key" {
  type = string
}

variable "priv_ssh_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "myip" {
  type = string
}

variable "aws_rds_db_name" {
  type = string
}

variable "aws_rds_db_username" {
  type = string
}

variable "aws_rds_db_pwd" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
  sensitive = true
}

variable "session_rec_s3_name" {
  type = string
}

variable "hcp_packer_url" {
  type = string
}

variable "hcp_packer_hmac" {
  type = string
}

variable "worker_name" {
  type = string
}

variable "worker_tag" {
  type = string
}