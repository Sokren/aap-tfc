locals {
  tags = {
    Name = "${var.tag}-${random_pet.test.id}"
  }

  pub_cidrs  = cidrsubnets("10.0.0.0/24", 4, 4, 4, 4)
  priv_cidrs = cidrsubnets("10.0.100.0/24", 4, 4, 4, 4)
}

variable "tag" {
  type = string
}

variable "num_targets" {
  default = 1
}

variable "num_subnets_public" {
  default = 3
}

variable "tls_disabled" {
  default = true
}

variable "region"{
  type = string
}
variable "myip" {
  type = string
}

variable "bsr_worker_filter" {
  type        = string
  description = "BSR default worker filter"
  default     = ""
}

variable "tfc_org" {
  type = string
}
