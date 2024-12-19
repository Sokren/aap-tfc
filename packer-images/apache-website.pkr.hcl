packer {
    required_plugins {
        amazon = {
            version = ">= 1.1.0"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu-boundary-target" {
    ami_name      = "Webserver Apache2"
    instance_type = "t3.micro"
    region        = "us-east-1"
    source_ami    =  "ami-055e8820ba220cf71"
    subnet_id     = "subnet-039d6995b144f2f83"
    ssh_private_key_file = ""
    tags = {
        "Name" = "Remi's packer image for us-east-1 "
    }
    ssh_username = "ubuntu"
}


build {
    hcp_packer_registry {
        bucket_name = "apache-website"
        description = <<EOT
            Images for ubuntu.
            EOT
    }
    name = "ubuntu-aws"
    sources = [
        "source.amazon-ebs.ubuntu-boundary-target",
    ]

    provisioner "shell" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install apache2 -y",
            "sudo systemctl enable apache2.service",
            "sudo systemctl start apache2.service"
        ]
    }
    provisioner "file" {
        source = "../website/Version-HC"
        destination = "/tmp"
    }
    provisioner "shell" {
        inline = [
        "sudo cp -r /tmp/Version-HC/* /var/www/html",
        ]
    }

      
}