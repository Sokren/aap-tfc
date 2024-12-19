output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet" {
  value = aws_subnet.public
}

output "alloceipfirst" {
  value = aws_eip.eipfirst.allocation_id
}

output "alloceipsecond" {
  value = aws_eip.eipsecond.allocation_id
}