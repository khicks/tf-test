variable "vpc_cidr" {
  type    = string
  default = "172.33.0.0/16"
}

variable "environment" {
  type    = string
  default = null
}

module "sandbox_vpc" {
  source = "../modules/vpc"

  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr
}

output "vpc" {
  value = module.sandbox_vpc.vpc
}

output "public_subnets" {
  value = module.sandbox_vpc.public_subnets
}

output "private_subnets" {
  value = module.sandbox_vpc.private_subnets
}

output "nat_ips" {
  value = module.sandbox_vpc.nat_ips
}
