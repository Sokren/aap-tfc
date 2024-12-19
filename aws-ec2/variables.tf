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

variable "pub_ssh_key" {
  type = string
}

variable "priv_ssh_key" {
  default = ""
}

variable "num_targets" {
  default = 2
}

variable "tfc_org" {
  type = string
}

variable "region" {
  type = string
}