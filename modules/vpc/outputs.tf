output "vpc" {
  value = {
    id   = aws_vpc.application_vpc.id
    cidr = aws_vpc.application_vpc.cidr_block
  }
}

output "public_subnets" {
  value = {
    ids   = aws_subnet.public_subnets.*.id
    cidrs = aws_subnet.public_subnets.*.cidr_block
  }
}

output "private_subnets" {
  value = {
    ids   = aws_subnet.private_subnets.*.id
    cidrs = aws_subnet.private_subnets.*.cidr_block
  }
}

output "nat_ips" {
  value = var.enable_nat_gw ? aws_eip.nat_eip.*.public_ip : null
}
