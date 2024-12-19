locals {
  priv_ssh_key_real = coalesce(var.priv_ssh_key,var.pub_ssh_key)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# data "hcp_packer_iteration" "boundary_target" {
#   bucket_name = "boundary-target"
#   channel     = "latest"
# }

# data "hcp_packer_image" "ubuntu_us_east_1" {
#   bucket_name    = "boundary-target"
#   cloud_provider = "aws"
#   iteration_id   = data.hcp_packer_iteration.boundary_target.ulid
#   region         = var.region
# }

data "hcp_packer_artifact" "apache-website" {
  bucket_name   = "apache-website"
  channel_name  = "latest"
  platform      = "aws"
  region        = "us-east-1"
}

resource "aws_key_pair" "boundary" {
  key_name   = "${var.tag}-${random_pet.test.id}"
  public_key = var.pub_ssh_key

  tags = local.tags
}

resource "aws_security_group" "worker" {
  vpc_id = data.terraform_remote_state.aws_infra.outputs.vpc_id

  tags = {
    Name = "${var.tag}-worker-${random_pet.test.id}"
  }
}

resource "aws_security_group_rule" "allow_ingress_controller" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}

resource "aws_security_group_rule" "allow_ingress_controller_httpds" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}

resource "aws_security_group_rule" "allow_ingress_controller_httpds8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}


resource "aws_security_group_rule" "allow_egress_controller" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}

# Example resource for connecting to through boundary over SSH
resource "aws_instance" "target" {
  count                         = var.num_targets
  ami                           = data.hcp_packer_artifact.apache-website.external_identifier
  #ami                           = data.aws_ami.ubuntu.id
  instance_type                 = "t3.micro"
  subnet_id                     = data.terraform_remote_state.aws_infra.outputs.subnet.*.id[count.index]
  key_name                      = aws_key_pair.boundary.key_name
  vpc_security_group_ids        = [aws_security_group.worker.id]
  tags = {
    Name = "${var.tag}-target-${random_pet.test.id}-${count.index}"
  }
  user_data = <<EOF
#!/bin/bash
sudo bash -c "echo ${data.terraform_remote_state.hcp_vault_manage.outputs.vault_boundary_ssh_ca} > /etc/ssh/ca-key.pub" \
sudo chown 1000:1000 /etc/ssh/ca-key.pub
sudo chmod 644 /etc/ssh/ca-key.pub
sudo bash -c "echo TrustedUserCAKeys /etc/ssh/ca-key.pub >> /etc/ssh/sshd_config"
sudo systemctl restart sshd.service
#sudo apt-get install apache2 -y
#sudo systemctl enable apache2.service
#sudo systemctl start apache2.service
  EOF
}

resource "aws_eip_association" "eip_assoc1" {
  instance_id   = aws_instance.target[0].id
  allocation_id = data.terraform_remote_state.aws_infra.outputs.alloceipfirst
}