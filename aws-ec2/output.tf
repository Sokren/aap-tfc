output "ec2_first_addr" {
  value = aws_eip_association.eip_assoc1.public_ip
}

output "ec2_first_addr_http" {
  value = "http://${aws_eip_association.eip_assoc1.public_ip}"
}

output "ec2_first_addr_aap_http" {
  value = "http://${aws_eip_association.eip_assoc1.public_ip}:8080"
}